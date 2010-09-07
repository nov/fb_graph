module FbGraph
  class Subscription < Node
    attr_accessor :object, :fields, :callback_url, :active

    def initialize(identifier, attributes = {})
      super
      @object       = attributes[:object]
      @fields       = attributes[:fields]
      @callback_url = attributes[:callback_url]
      @active       = attributes[:active]
    end
  end
end