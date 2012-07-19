module FbGraph
  module Connections
    module Inbox
      def inbox(options = {})
        threads = self.connection :inbox, options
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