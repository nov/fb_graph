module FbGraph
  module Connections
    module UserLikes
      def likes(options = {})
        likes = self.connection :likes, options
        likes.map! do |like|
          Page.new like[:id], like.merge(
            :access_token => options[:access_token] || self.access_token
          )
        end
      end

      def like?(page, options = {})
        like = self.connection :likes, options.merge(:connection_scope => page.identifier)
        like.present?
      end
    end
  end
end