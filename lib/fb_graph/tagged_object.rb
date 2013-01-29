module FbGraph
  class TaggedObject < Node
    attr_accessor :name, :offset, :length

    def initialize(identifier, attributes = {})
      super
      [:name, :offset, :length].each do |key|
        self.send("#{key}=", attributes[key])
      end
    end

    def fetch_with_class_determination
      attributes = fetch_without_class_determination.raw_attributes
      klass = if attributes[:category]
        Page
      else
        User
      end
      klass.new attributes[:id], attributes
    end
    alias_method_chain :fetch, :class_determination
  end
end