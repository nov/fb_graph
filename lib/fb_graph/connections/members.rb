module FbGraph
  module Connections
    module Members
      def members(options = {})
        members = FbGraph::Collection.new(get(options.merge(:connection => 'members')))
        members.map! do |member|
          User.new(member.delete(:id), member)
        end
      end
    end
  end
end