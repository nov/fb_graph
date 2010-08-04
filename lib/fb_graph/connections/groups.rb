module FbGraph
  module Connections
    module Groups
      def groups(options = {})
        groups = FbGraph::Collection.new(get(options.merge(:connection => 'groups')))
        groups.map! do |group|
          Group.new(group.delete(:id), group.merge(
            :access_token => options[:access_token] || self.access_token
          ))
        end
      end
    end
  end
end