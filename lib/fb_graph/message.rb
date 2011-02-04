module FbGraph
  class Message < Node
    # TODO:
    # include Connections::Attachments
    # include Connections::Shares

    attr_accessor :subject, :message, :from, :to, :tags, :created_time

    def initialize(identifier, attributes = {})
      super
      @subject = attributes[:subject]
      @message = attributes[:message]
      if (from = attributes[:from])
        @from = User.new(from.delete(:id), from)
      end
      @to = []
      if attributes[:to]
        Collection.new(attributes[:to]).each do |to|
          @to << User.new(to.delete(:id), to)
        end
      end
      @tags = []
      if attributes[:tags]
        Collection.new(attributes[:tags]).each do |tag|
          @tags << Tag.new(tag)
        end
      end
      if attributes[:created_time]
        @created_time = Time.parse(attributes[:created_time]).utc
      end
    end
  end
end
