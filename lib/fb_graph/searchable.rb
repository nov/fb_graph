module FbGraph
  module Searchable
    def self.search(query, options = {})
      results = FbGraph::Collection.new(
        Node.new(:search).send(:get, options.merge(:q => query))
      )
      yield results if block_given?
      Result.new(query, self, options.merge(:results => results))
    end

    def search(query, options = {})
      type = self.to_s.underscore.split('/').last
      FbGraph::Searchable.search(query, options.merge(:type => type)) do |results|
        results.map! do |result|
          self.new(result.delete(:id), result.merge(
            :access_token => options[:access_token]
          ))
        end
      end
    end

    class Result < Collection
      attr_accessor :results

      def initialize(query, type, options = {})
        @type = type
        @query = query
        @options = options
        @results = options[:results] || FbGraph::Collection.new
        replace @results
      end

      def next(_options_ = {})
        if self.results.next.present?
          self.type.send(:search, self.query, self.options.merge(_options_).merge(self.results.next))
        else
          self.class.new(self.query, self.type)
        end
      end

      def previous(_options_ = {})
        if self.results.previous.present?
          self.type.send(:search, self.query, self.options.merge(_options_).merge(self.results.previous))
        else
          self.class.new(self.query, self.type)
        end
      end
    end
  end
end
