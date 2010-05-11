module FbGraph
  module Connections
    module Invited
      def invited(options = {})
        members = FbGraph::Collection.new(get(options.merge(:connection => 'invited')))
        members.map! do |member|
          User.new(member.delete(:id), member)
        end
      end
    end
  end
end