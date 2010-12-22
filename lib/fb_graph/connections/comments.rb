module FbGraph
  module Connections
    module Comments
      def comments(options = {})
        comments = if @_comments_ && options.blank?
          # Note:
          # "comments" is a connection, but included in fetched object
          # this improves performance when rendering the stream with comments
          @_comments_
        else
          self.connection(:comments, options)
        end
        comments.map! do |comment|
          Comment.new(comment.delete(:id), comment.merge(
            :access_token => options[:access_token] || self.access_token
          ))
        end
      end

      def comment!(options = {})
        comment = post(options.merge(:connection => 'comments'))
        Comment.new(comment.delete(:id), options.merge(comment).merge(
          :access_token => options[:access_token] || self.access_token
        ))
      end

      # NOTE:
      # the context of getting likes is User, but the context of posting like is not user.
      # posting like is always in same context with comment!
      def like!(options = {})
        post(options.merge(:connection => 'likes'))
      end

      def unlike!(options = {})
        destroy(options.merge(:connection => 'likes'))
      end
    end
  end
end