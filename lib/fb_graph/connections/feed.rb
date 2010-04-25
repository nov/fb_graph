module FbGraph
  module Connections
    module Feed
      def feed(options = {})
        unless @posts
          @posts = get(options.merge(:connection => 'feed'))
          @posts[:data].map! do |post|
            Post.new(post.delete(:id), post)
          end
        end
        Collection.new(@posts)
      end
    end
  end
end