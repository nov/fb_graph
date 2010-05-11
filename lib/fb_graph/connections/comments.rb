module FbGraph
  module Connections
    module Comments
      def comments(options = {})
        comments = if @_comments_.present? && options.blank?
          # Note:
          # "comments" is a connection, but included in fetched "post" object
          # this improves performance when rendering the stream with comments
          @_comments_
        else
          FbGraph::Collection.new(get(options.merge(:connection => 'comments')))
        end
        comments.map! do |comment|
          Comment.new(comment.delete(:id), comment)
        end
      end

      def comment!(options = {})
        comment = post(options.merge(:connection => 'comments'))
        Comment.new(comment.delete(:id), options.merge(comment))
      end

      # NOTE:
      # the context of getting likes is User, but the context of posting like is not user.
      # posting like is always in same context with comment!
      def like!(options = {})
        post(options.merge(:connection => 'likes'))
      end
    end
  end
end