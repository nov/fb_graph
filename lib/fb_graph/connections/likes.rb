module FbGraph
  module Connections
    module Likes
      def likes(options = {})
        likes = self.connection :likes, options
        likes.map! do |like|
          like.merge!(
            :access_token => options[:access_token] || self.access_token
          )
          if like[:category]
            Page.new like[:id], like
          else
            User.new like[:id], like
          end
        end
      end

      module Likable
        def like!(options = {})
          post options.merge(:connection => :likes)
        end

        def unlike!(options = {})
          destroy options.merge(:connection => :likes)
        end
      end
    end
  end
end