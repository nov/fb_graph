module FbGraph
  module Connections
    module Groups
      def groups(options = {})
        groups = Collection.new(get(options.merge(:connection => 'groups')))
        groups.map! do |group|
          Group.new(group.delete(:id), group)
        end
      end
    end
  end
end