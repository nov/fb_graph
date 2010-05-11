module FbGraph
  class Link < Node
    include Connections::Comments

    attr_accessor :from, :link, :message, :updated_time

    def initialize(identifier, options = {})
      super
      if (from = options[:from])
        @from = if from[:category]
          FbGraph::Page.new(from.delete(:id), from)
        else
          FbGraph::User.new(from.delete(:id), from)
        end
      end
      @link         = options[:link]
      @message      = options[:message]
      if options[:updated_time]
        @updated_time = Time.parse(options[:updated_time]).utc
      end
    end
  end
end