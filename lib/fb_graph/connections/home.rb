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
        Collection.new(@posts)
      end
    end
  end
end