module FbGraph
  module Connections
    module Statuses
      def statuses(options = {})
        unless @statuses
          @statuses = get(options.merge(:connection => 'statuses'))
          @statuses[:data].map! do |status|
            Status.new(status[:id], :from => status[:from], :message => status[:message], :updated_time => status[:updated_time])
          end
        end
        @statuses
      end
    end
  end
end