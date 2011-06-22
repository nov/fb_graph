module FbGraph
  module Connections
    module Outbox
      def outbox(options = {})
        threads = self.connection(:outbox, options)
        threads.map! do |thread|
          # NOTE:
          #  Inbox API doesn't return thread object until their message platform becomes broadly available.
          #  Use Post instead of Thread for now.
          Post.new(thread[:id], thread.merge(
            :access_token => options[:access_token] || self.access_token
          ))
        end
      end
    end
  end
end