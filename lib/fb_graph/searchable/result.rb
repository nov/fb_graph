module FbGraph
  module Searchable
    class Result < Collection
      attr_accessor :query, :klass, :collection, :options

      def initialize(query, klass, options = {})
        @klass = klass
        @query = query
        @options = options
        @collection = options.delete(:collection) || Collection.new
        replace @collection
      end

      def next(_options_ = {})
        if self.collection.next.present?
          self.klass.search(self.query, self.options.merge(_options_).merge(self.collection.next))
        else
          self.class.new(self.query, self.klass)
        end
      end

      def previous(_options_ = {})
        if self.collection.previous.present?
          self.klass.search(self.query, self.options.merge(_options_).merge(self.collection.previous))
        else
          self.class.new(self.query, self.klass)
        end
      end
    end
  end
end