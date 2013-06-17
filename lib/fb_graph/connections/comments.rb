module FbGraph
  module Connections
    module Comments
      def comments(options = {})
        comments = self.connection :comments, options
        comments.map! do |comment|
          Comment.new comment[:id], comment.merge(
            :access_token => options[:access_token] || self.access_token
          )
        end
      end

      def comment!(options = {})
        comment = post options.merge(:connection => :comments)
        Comment.new comment[:id], options.merge(comment).merge(
          :access_token => options[:access_token] || self.access_token
        )
      end

      def reply!(options = {})
        comment_id = post options.merge(:connection => :comments)
        Comment.new comment_id, options.merge(
          :access_token => options[:access_token] || self.access_token
        )
      end
    end
  end
end