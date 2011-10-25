module FbGraph
  class FriendList < Node
    include Connections::Members

    attr_accessor :name, :list_type

    def initialize(identifier, attributes = {})
      super
      @name = attributes[:name]
      @list_type = attributes[:list_type]
    end
  end
end