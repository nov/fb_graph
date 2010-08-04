module FbGraph
  module Connections
    module Tagged
      def tagged(options = {})
        posts = FbGraph::Collection.new(get(options.merge(:connection => 'tagged')))
        posts.map! do |post|
          Post.new(post.delete(:id), post.merge(
            :access_token => options[:access_token] || self.access_token
          ))
        end
      end
    end
  end
end