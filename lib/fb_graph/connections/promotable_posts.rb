module FbGraph
  module Connections
    module PromotablePosts
      def promotable_posts(options = {})
        posts = self.connection :promotable_posts, options
        posts.map! do |post|
          PromotablePost.new post[:id], post.merge(
            :access_token => options[:access_token] || self.access_token
          )
        end
      end
    end
  end
end