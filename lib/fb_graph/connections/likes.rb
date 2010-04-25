module FbGraph
  module Connections
    module Likes
      def likes(options = {})
        likes = Collection.new(get(options.merge(:connection => 'likes')))
        likes.map! do |like|
          Page.new(like.delete(:id), like)
        end
      end
    end
  end
end