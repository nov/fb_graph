module FbGraph
  class FriendRequest
    include Comparison
    attr_accessor :from, :to, :created_time, :message, :unread

    def initialize(attributes = {})
      @from = User.new attributes[:from]
      @to = User.new attributes[:to]
      @created_time = Time.parse attributes[:created_time]
      @message = attributes[:message]
      @unread = attributes[:unread]
    end
  end
end