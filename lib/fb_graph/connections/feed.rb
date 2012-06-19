module FbGraph
  module Connections
    module Feed
      def feed(options = {}, &block)
        self.connection :feed, options do |posts|
          response = posts.map! do |post|
            Post.new post[:id], post.merge(
              :context => self.class,
              :access_token => options[:access_token] || self.access_token
            )
          end
          block_given? ? (yield response) : response
        end
      end

      def feed!(options = {}, &block)
        post options.merge(:connection => :feed, :_class => Hash) do |post|
          response = Post.new post[:id], options.merge(post).merge(
            :access_token => options[:access_token] || self.access_token
          )
          block_given? ? (yield response) : response
        end
      end
    end
  end
end
