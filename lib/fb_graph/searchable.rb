module FbGraph
  module Searchable
    def self.search(query, options = {})
      klass = options.delete(:class) || Searchable
      query_param = klass.search_query_param
      collection = Collection.new(
        Node.new(:search).send(:get, options.merge(query_param.to_sym => query))
      )
      yield collection if block_given?
      Searchable::Result.new(query, klass, options.merge(:collection => collection))
    end

    def search(query, options = {})
      type = self.to_s.underscore.split('/').last.gsub("_", "")
      Searchable.search(query, options.merge(:type => type, :class => self)) do |collection|
        collection.map! do |obj|
          self.new(obj[:id], obj.merge(
            :access_token => options[:access_token]
          ))
        end
      end
    end

    # The majority of Graph API searches use 'q' but some, like AdKeywordSuggestion
    # use an alternate search query param
    def self.search_query_param
      :q
    end
    delegate :search_query_param, :to => Searchable
  end
end

require 'fb_graph/searchable/result'
