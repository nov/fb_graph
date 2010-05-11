module FbGraph
  module Connections
    module Attending
      def attending(options = {})
        members = FbGraph::Collection.new(get(options.merge(:connection => 'attending')))
        members.map! do |member|
          User.new(member.delete(:id), member)
        end
      end

      def attending!(options = {})
        post(options.merge(:connection => 'attending'))
      end
    end
  end
end