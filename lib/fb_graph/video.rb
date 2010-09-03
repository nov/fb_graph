module FbGraph
  class Video < Node
    include Connections::Comments
    include Connections::Likes

    attr_accessor :from, :message, :description, :length, :created_time, :updated_time

    def initialize(identifier, options = {})
      super
      if (from = options[:from])
        @from = if from[:category]
          FbGraph::Page.new(from.delete(:id), from)
        else
          FbGraph::User.new(from.delete(:id), from)
        end
      end
      @message     = options[:message]
      @description = options[:description]
      @length      = options[:length]
      if options[:created_time]
        @created_time = Time.parse(options[:created_time]).utc
      end
      if options[:updated_time]
        @updated_time = Time.parse(options[:updated_time]).utc
      end
    end
  end
end