module FbGraph
  class Note < Node
    include Connections::Comments

    attr_accessor :from, :subject, :message, :created_time, :updated_time

    def initialize(identifier, options = {})
      super
      if (from = options[:from])
        @from = if from[:category]
          FbGraph::Page.new(from.delete(:id), from)
        else
          FbGraph::User.new(from.delete(:id), from)
        end
      end
      @subject      = options[:subject]
      @message      = options[:message]
      if options[:created_time]
        @created_time = Time.parse(options[:created_time]).utc
      end
      if options[:updated_time]
        @updated_time = Time.parse(options[:updated_time]).utc
      end
    end
  end
end