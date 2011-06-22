module FbGraph
  module Connections
    module Inbox
      def inbox(options = {})
        threads = self.connection(:inbox, options)
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