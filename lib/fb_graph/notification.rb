module FbGraph
  class Notification < Node
    attr_accessor :from, :to, :created_time, :updated_time, :title, :link, :application, :unread

    def initialize(identifier, attributes = {})
      super
      @name = attributes[:name]
    end

    def read!(options = {})
      post options.merge(:unread => 0)
    end
  end
end