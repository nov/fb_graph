module FbGraph
  module Connections
    module Permissions
      def permissions(options = {})
        if FbGraph.v2?
          self.connection(:permissions, options).try(:inject, []) do |arr, entry|
            arr << entry[:permission].to_sym if entry[:status] == 'granted'
            arr
          end || []
        else
          self.connection(:permissions, options).first.try(:inject, []) do |arr, (key, value)|
            arr << key.to_sym if value.to_i == 1
            arr
          end || []
        end
      end

      def revoke!(permission = nil, options = {})
        destroy options.merge(:permission => permission, :connection => :permissions)
      end
    end
  end
end