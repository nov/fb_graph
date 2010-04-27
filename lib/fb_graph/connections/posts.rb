module FbGraph
  module Connections
    module Posts
      def posts(options = {})
        posts = FbGraph::Collection.new(get(options.merge(:connection => 'posts')))
        posts.map! do |post|
          Post.new(post.delete(:id), post)
        end
      end
    end
  end
end