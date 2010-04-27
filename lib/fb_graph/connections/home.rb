module FbGraph
  module Connections
    module Home
      def home(options = {})
        posts = FbGraph::Collection.new(get(options.merge(:connection => 'home')))
        posts.map! do |post|
          Post.new(post.delete(:id), post)
        end
      end
    end
  end
end