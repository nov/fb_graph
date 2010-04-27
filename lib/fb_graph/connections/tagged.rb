module FbGraph
  module Connections
    module Tagged
      def tagged(options = {})
        posts = FbGraph::Collection.new(get(options.merge(:connection => 'tagged')))
        posts.map! do |post|
          Post.new(post.delete(:id), post)
        end
      end
    end
  end
end