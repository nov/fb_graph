module FbGraph
  class AdKeywordValid < Node
    extend Searchable

    attr_accessor :name, :valid, :suggestions

    def initialize(identifier, attributes = {})
      super

      %w(name valid).each do |field|
        self.send("#{field}=", attributes[field.to_sym])
      end

      self.suggestions = attributes[:suggestions].collect {|s| FbGraph::AdKeyword.new(s['id'], s)} if attributes[:suggestions]
    end

    alias :valid? :valid

    def self.search_query_param
      :keyword_list
    end
  end
end
