module FbGraph
  module Connections
    module Likes
      def likes(options = {})
        likes = get(options.merge(:connection => 'likes'))
        likes[:data].map! do |like|
          Page.new(like.delete(:id), like)
        end
        Collection.new(likes)
      end
    end
  end
end