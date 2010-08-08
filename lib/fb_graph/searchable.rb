module FbGraph
  module Searchable
    def search(query, options = {})
      results = Node.search(query, options.merge(:type => self.to_s.downcase))
      results.map! do |result|
        type.new(result.delete(:id), result.merge(
          :access_token => options[:access_token]
        ))
      end
      Search.new(query, self, options.merge(:results => results))
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
