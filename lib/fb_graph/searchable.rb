module FbGraph
  module Searchable
    def self.search(query, options = {})
      klass = options.delete(:class) || FbGraph::Searchable
      collection = FbGraph::Collection.new(
        FbGraph::Node.new(:search).send(:get, options.merge(:q => query))
      )
      yield collection if block_given?
      FbGraph::Searchable::Result.new(query, klass, options.merge(:collection => collection))
    end

    def search(query, options = {})
      type = self.to_s.underscore.split('/').last
      FbGraph::Searchable.search(query, options.merge(:type => type, :class => self)) do |collection|
        collection.map! do |obj|
          self.new(obj.delete(:id), obj.merge(
            :access_token => options[:access_token]
          ))
        end
      end
    end

    class Result < Collection
      attr_accessor :query, :klass, :collection, :options

      def initialize(query, klass, options = {})
        @klass = klass
        @query = query
        @options = options
        @collection = options.delete(:collection) || FbGraph::Collection.new
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
          self.klassf.search(self.query, self.options.merge(_options_).merge(self.collection.previous))
        else
          self.class.new(self.query, self.klass)
        end
      end
    end
  end
end