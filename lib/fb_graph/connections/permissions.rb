module FbGraph
  module Connections
    module Permissions
      def permissions(options = {})
        self.connection(:permissions, options).first.try(:inject, []) do |arr, (key, value)|
          arr << key.to_sym if value.to_i == 1
          arr
        end || []
      end

      def revoke!(permission = nil, options = {})
        destroy options.merge(:permission => permission, :connection => :permissions)
      end
    end
  end
end