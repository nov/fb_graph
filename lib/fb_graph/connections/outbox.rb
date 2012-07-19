module FbGraph
  module Connections
    module Outbox
      def outbox(options = {})
        threads = self.connection :outbox, options
        threads.map! do |thread|
          if thread[:comments]
            Thread::BeforeTransition.new thread[:id], thread.merge(
              :access_token => options[:access_token] || self.access_token
            )
          else
            Thread.new thread[:id], thread.merge(
              :access_token => options[:access_token] || self.access_token
            )
          end
        end
      end
    end
  end
end