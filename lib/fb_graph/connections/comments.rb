module FbGraph
  module Connections
    module Comments
      def comments(options = {})
        comments = FbGraph::Collection.new(get(options.merge(:connection => 'comments')))
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