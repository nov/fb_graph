module FbGraph
  module Connections
    module Statuses
      def statuses(options = {})
        statuses = Collection.new(get(options.merge(:connection => 'statuses')))
        statuses.map! do |status|
          Status.new(status.delete(:id), status)
        end
      end
    end
  end
end