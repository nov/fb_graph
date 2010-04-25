module FbGraph
  module Connections
    module Statuses
      def statuses(options = {})
        statuses = get(options.merge(:connection => 'statuses'))
        statuses[:data].map! do |status|
          Status.new(status.delete(:id), status)
        end
        Collection.new(statuses)
      end
    end
  end
end