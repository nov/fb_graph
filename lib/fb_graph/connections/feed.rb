module FbGraph
  module Connections
    module Feed
      def feed(options = {})
        posts = FbGraph::Collection.new(get(options.merge(:connection => 'feed')))
        posts.map! do |post|
          Post.new(post.delete(:id), post)
        end
      end
    end
  end
end