module FbGraph
  class AppRequest < Node

    attr_accessor :application, :created_time, :data, :from, :message, :to

    def initialize(identifier, attributes = {})
      super
      @application  = Application.new(attributes[:application].delete(:id), attributes[:application])
      @created_time = attributes[:created_time]
      @data         = attributes[:data]
      @from         = User.new(attributes[:from].delete(:id), attributes[:from])
      @message      = attributes[:message]
      @to           = User.new(attributes[:to].delete(:id), attributes[:to])
    end
  end
end
