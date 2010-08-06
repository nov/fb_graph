module FbGraph
  module Connections
    module Groups
      def groups(options = {})
        groups = self.connection(:groups, options)
        groups.map! do |group|
          Group.new(group.delete(:id), group.merge(
            :access_token => options[:access_token] || self.access_token
          ))
        end
      end
    end
  end
end