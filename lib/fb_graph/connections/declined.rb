module FbGraph
  module Connections
    module Declined
      def declined(options = {})
        members = FbGraph::Collection.new(get(options.merge(:connection => 'declined')))
        members.map! do |member|
          User.new(member.delete(:id), member)
        end
      end

      def declined!(options = {})
        post(options.merge(:connection => 'declined'))
      end
    end
  end
end