module FbGraph
  class TestUser < Node
    include Connections::Friends

    attr_accessor :login_url

    def initialize(identifier, attributes = {})
      super
      @login_url = attributes[:login_url]
    end
  end
end