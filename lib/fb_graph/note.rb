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
      @created_time = options[:created_time]
      @updated_time = options[:updated_time]
    end
  end
end