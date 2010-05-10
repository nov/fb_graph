module FbGraph
  class Status < Node
    include Connections::Comments

    attr_accessor :from, :message, :updated_time

    def initialize(identifier, options = {})
      super
      if (from = options[:from])
        @from = if from[:category]
          FbGraph::Page.new(from.delete(:id), from)
        else
          FbGraph::User.new(from.delete(:id), from)
        end
      end
      @message = options[:message]
      if (updated_time = options.delete(:updated_time))
        @updated_time = Time.parse(updated_time)
      end
    end
  end
end