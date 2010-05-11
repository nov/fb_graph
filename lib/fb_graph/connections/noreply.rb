module FbGraph
  module Connections
    module Noreply
      def noreply(options = {})
        members = FbGraph::Collection.new(get(options.merge(:connection => 'noreply')))
        members.map! do |member|
          User.new(member.delete(:id), member)
        end
      end
    end
  end
end