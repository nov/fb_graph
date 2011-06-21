module FbGraph
  class FriendList < Node
    include Connections::Members

    attr_accessor :name, :type

    def initialize(identifier, attributes = {})
      super
      @name = attributes[:name]
      @type = attributes[:type]
    end
  end
end