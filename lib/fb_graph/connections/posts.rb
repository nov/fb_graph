module FbGraph
  module Connections
    module Posts
      def posts(options = {})
        posts = self.connection :posts, options
        posts.map! do |post|
          Post.new post[:id], post.merge(
            :access_token => options[:access_token] || self.access_token
          )
        end
      end
    end
  end
end