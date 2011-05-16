module FbGraph
  class AppRequest < Node

    attr_accessor :application, :created_time, :data, :from, :message, :to

    def initialize(identifier, attributes = {})
      super
      @data = attributes[:data]
      @message = attributes[:message]
      if attributes[:from]
        @from = User.new(attributes[:from][:id], attributes[:from])
      end
      if attributes[:to]
        @to = User.new(attributes[:to][:id], attributes[:to])
      end
      if attributes[:application]
        @application = Application.new(attributes[:application][:id], attributes[:application])
      end
      if attributes[:created_time]
        @created_time = Time.parse(attributes[:created_time]).utc
      end
    end
  end
end
