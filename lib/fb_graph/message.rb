module FbGraph
  class Message < Node
    # TODO:
    # include Connections::Attachments
    # include Connections::Shares
    include Connections::Tags

    attr_accessor :message, :from, :to, :created_time

    def initialize(identifier, attributes = {})
      super
      @message = attributes[:message]
      if (from = attributes[:from])
        @from = User.new(from[:id], from)
      end
      @to = []
      if attributes[:to]
        Collection.new(attributes[:to]).each do |to|
          @to << User.new(to[:id], to)
        end
      end
      if attributes[:created_time]
        @created_time = Time.parse(attributes[:created_time]).utc
      end

      # cached connection
      cache_collection attributes, :tags
    end
  end
end
