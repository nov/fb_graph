module FbGraph
  module Connections
    module Statuses
      def statuses(options = {})
        statuses = self.connection :statuses, options
        statuses.map! do |status|
          Status.new status[:id], status.merge(
            :access_token => options[:access_token] || self.access_token
          )
        end
      end
    end
  end
end