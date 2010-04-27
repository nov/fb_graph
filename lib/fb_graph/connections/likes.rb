module FbGraph
  module Connections
    module Likes
      def likes(options = {})
        likes = FbGraph::Collection.new(get(options.merge(:connection => 'likes')))
        likes.map! do |like|
          Page.new(like.delete(:id), like)
        end
      end
    end
  end
end