module FbGraph
  class Subscription < Node
    attr_accessor :object, :fields, :callback_url, :active

    def initialize(identifier, options = {})
      super
      # TODO
    end
  end
end