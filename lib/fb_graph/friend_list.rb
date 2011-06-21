module FbGraph
  class FriendList < Node
    include Connections::Members

    attr_accessor :name

    def initialize(identifier, attributes = {})
      super
      @name = attributes[:name]
    end
  end
end