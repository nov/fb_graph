module FbGraph
  module Connections
    module Feed
      def feed(options = {})
        posts = FbGraph::Collection.new(get(options.merge(:connection => 'feed')))
        posts.map! do |post|
          Post.new(post.delete(:id), post)
        end
      end

      def feed!(options = {})
        post = post(options.merge(:connection => 'feed'))
        Post.new(post.delete(:id), options.merge(post))
      end
    end
  end
end