module FbGraph
  module Connections
    module Noreply
      def noreply(options = {})
        members = Collection.new(get(options.merge(:connection => 'noreply')))
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