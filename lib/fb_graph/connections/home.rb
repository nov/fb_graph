module FbGraph
  module Connections
    module Home
      def home(options = {})
        posts = get(options.merge(:connection => 'home'))
        posts[:data].map! do |post|
          Post.new(post.delete(:id), post)
        end
        Collection.new(posts)
      end
    end
  end
end