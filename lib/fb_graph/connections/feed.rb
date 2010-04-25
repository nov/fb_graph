module FbGraph
  module Connections
    module Feed
      def feed(options = {})
        posts = get(options.merge(:connection => 'feed'))
        posts[:data].map! do |post|
          Post.new(post.delete(:id), post)
        end
        Collection.new(posts)
      end
    end
  end
end