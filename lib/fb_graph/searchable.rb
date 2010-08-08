module FbGraph
  module Searchable
    def search(query, options = {})
      results = FbGraph::Collection.new(
        Node.fetch(:search, options.merge(:q => query, :type => self.to_s.downcase))
      )
      Search.new(query, self, options.merge(:results => results))
    end

    class Search < Collection
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
