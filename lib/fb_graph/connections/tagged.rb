module FbGraph
  module Connections
    module Tagged
      def tagged(options = {})
        unless @posts
          @posts = get(options.merge(:connection => 'tagged'))
          @posts[:data].map! do |post|
            Post.new(post.delete(:id), post)
          end
        end
        @post
      end
    end
  end
end