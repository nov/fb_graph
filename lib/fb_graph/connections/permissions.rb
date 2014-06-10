module FbGraph
  module Connections
    module Permissions
      def permissions(options = {})
        self.connection(:permissions, options).try(:inject, []) do |arr, entry|
          if entry.include? :status
            # v2.0
            arr << entry[:permission].to_sym if entry[:status] == 'granted'
          else
            # v1.0
            entry.each do |key, value|
              arr << key.to_sym if value.to_i == 1
            end
          end
          arr
        end || []
      end

      def revoke!(permission = nil, options = {})
        destroy options.merge(:permission => permission, :connection => :permissions)
      end
    end
  end
end