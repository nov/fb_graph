module FbGraph
  module Connections
    module Invited
      def invited(options = {})
        members = FbGraph::Collection.new(get(options.merge(:connection => 'invited')))
        members.map! do |member|
          if member[:category]
            Page.new(member.delete(:id), member)
          else
            User.new(member.delete(:id), member)
          end
        end
      end
    end
  end
end