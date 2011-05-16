module FbGraph
  module Searchable
    def self.search(query, options = {})
      klass = options.delete(:class) || Searchable
      collection = Collection.new(
        Node.new(:search).send(:get, options.merge(:q => query))
      )
      yield collection if block_given?
      Searchable::Result.new(query, klass, options.merge(:collection => collection))
    end

    def search(query, options = {})
      type = self.to_s.underscore.split('/').last
      Searchable.search(query, options.merge(:type => type, :class => self)) do |collection|
        collection.map! do |obj|
          self.new(obj[:id], obj.merge(
            :access_token => options[:access_token]
          ))
        end
      end
    end
  end
end

require 'fb_graph/searchable/result'