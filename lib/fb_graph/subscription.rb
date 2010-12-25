module FbGraph
  class Subscription
    include Comparison

    attr_accessor :object, :fields, :callback_url, :active

    def initialize(attributes = {})
      @object       = attributes[:object]
      @fields       = attributes[:fields]
      @callback_url = attributes[:callback_url]
      @active       = attributes[:active]
    end
  end
end