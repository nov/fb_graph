module FbGraph
  class AdKeyword < Node
    extend Searchable

    attr_accessor :name, :description

    def initialize(identifier, attributes = {})
      super

      %w(name description).each do |field|
        self.send("#{field}=", attributes[field.to_sym])
      end
    end

    def topic_keyword?
      (name =~ /^#/) == 0
    end
  end
end

