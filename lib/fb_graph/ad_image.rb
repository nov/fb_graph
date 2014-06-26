module FbGraph
  class AdImage < Node
    
    ATTRS = [
      :hash,
      :url
    ]

    attr_accessor *ATTRS
    def initialize(identifier, attributes = {})
      super
      set_attrs(attributes)
    end

    protected

    def set_attrs(attributes)
      ATTRS.each do |field|
        send("#{field}=", attributes[field.to_sym])
      end
    end
  end
end
