module FbGraph
  module Connections
    module Likes
      def likes(options = {})
        likes = if @_likes_ && options.blank?
          self.connection(:likes, options.merge(:cached_collection => @_likes_))
        else
          self.connection(:likes, options)
        end
        likes.map! do |like|
          like.merge!(
            :access_token => options[:access_token] || self.access_token
          )
          if like[:category]
            Page.new(like[:id], like)
          else
            User.new(like[:id], like)
          end
        end
      end

      def like!(options = {})
        post(options.merge(:connection => :likes))
      end

      def unlike!(options = {})
        destroy(options.merge(:connection => :likes))
      end
    end
  end
end