module FbGraph
  class BroadTargetingCategory < Node
    attr_accessor :name, :parent_category

    def initialize(identifier, attributes = {})
      super

      %w(name parent_category).each do |field|
        self.send("#{field}=", attributes[field.to_sym])
      end
    end
  end
end
