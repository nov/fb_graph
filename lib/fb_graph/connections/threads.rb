module FbGraph
  module Connections
    module Threads
      def threads(options = {})
        threads = self.connection :threads, options
        threads.map! do |thread|
          Thread.new thread[:id], thread.merge(
            :access_token => options[:access_token] || self.access_token
          )
        end
      end
    end
  end
end