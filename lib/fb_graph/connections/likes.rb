module FbGraph
  module Connections
    module Likes
      def likes(options = {})
        unless @likes
          @likes = get(options.merge(:connection => 'likes'))
          @likes[:data].map! do |like|
            Page.new(like.delete(:id), like)
          end
        end
        @likes
      end
    end
  end
end