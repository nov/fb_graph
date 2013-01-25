module FbGraph
  module Connections
    module Home
      def home(options = {})
        posts = self.connection :home, options
        posts.map! do |post|
          Post.new post[:id], post.merge(
            :access_token => options[:access_token] || self.access_token
          )
        end
      end
    end
  end
end