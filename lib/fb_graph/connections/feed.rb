module FbGraph
  module Connections
    module Feed
      def feed(options = {})
        posts = self.connection :feed, options
        posts.map! do |post|
          Post.new post[:id], post.merge(
            :access_token => options[:access_token] || self.access_token
          )
        end
      end

      def feed!(options = {})
        post = post options.merge(:connection => :feed)
        Post.new post[:id], options.merge(post).merge(
          :access_token => options[:access_token] || self.access_token
        )
      end
    end
  end
end