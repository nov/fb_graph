module FbGraph
  module Connections
    module Declined
      def declined(options = {})
        members = FbGraph::Collection.new(get(options.merge(:connection => 'declined')))
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