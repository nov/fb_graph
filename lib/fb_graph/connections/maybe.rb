module FbGraph
  module Connections
    module Maybe
      def maybe(options = {})
        members = Collection.new(get(options.merge(:connection => 'maybe')))
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