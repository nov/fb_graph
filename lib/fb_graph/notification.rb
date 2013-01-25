module FbGraph
  class Notification < Node
    attr_accessor :application, :from, :to, :title, :message, :link, :unread, :created_time, :updated_time

    def initialize(identifier, attributes = {})
      super
      @title = attributes[:title]
      @message = attributes[:message]
      @link = attributes[:link]
      @unread = attributes[:unread] == 1
      if (application = attributes[:application])
        @application = Application.new(application[:id], application)
      end
      if (from = attributes[:from])
        @from = User.new(from[:id], from)
      end
      if (to = attributes[:to])
        @to = User.new(to[:id], to)
      end
      if attributes[:created_time]
        @created_time = Time.parse(attributes[:created_time]).utc
      end
      if attributes[:updated_time]
        @updated_time = Time.parse(attributes[:updated_time]).utc
      end
    end

    def read!(options = {})
      post options.merge(:unread => false)
    end
  end
end