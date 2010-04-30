module FbGraph
  module Connections
    module Attending
      def attending(options = {})
        members = FbGraph::Collection.new(get(options.merge(:connection => 'attending')))
        members.map! do |member|
          if member[:category]
            Page.new(member.delete(:id), member)
          else
            User.new(member.delete(:id), member)
          end
        end
      end

      def attending!(options = {})
        post(options.merge(:connection => 'attending'))
      end
    end
  end
end