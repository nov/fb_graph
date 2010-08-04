module FbGraph
  module Connections
    module Statuses
      def statuses(options = {})
        statuses = FbGraph::Collection.new(get(options.merge(:connection => 'statuses')))
        statuses.map! do |status|
          Status.new(status.delete(:id), status.merge(
            :access_token => options[:access_token] || self.access_token
          ))
        end
      end
    end
  end
end