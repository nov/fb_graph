module FbGraph
  module Connections
    module Posts
      def posts(options = {})
        posts = get(options.merge(:connection => 'posts'))
        posts[:data].map! do |post|
          Post.new(post.delete(:id), post)
        end
        Collection.new(posts)
      end
    end
  end
end