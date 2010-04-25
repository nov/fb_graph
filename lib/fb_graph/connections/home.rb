module FbGraph
  module Connections
    module Home
      def home(options = {})
        unless @posts
          @posts = get(options.merge(:connection => 'home'))
          @posts[:data].map! do |post|
            Post.new(post.delete(:id), post)
          end
        end
        @post
      end
    end
  end
end