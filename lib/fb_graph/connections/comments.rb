module FbGraph
  module Connections
    module Comments
      def comments(options = {})
        comments = if @_comments_ && options.blank?
          self.connection(:comments, options.merge(:cached_collection => @_comments_))
        else
          self.connection(:comments, options)
        end
        comments.map! do |comment|
          Comment.new(comment[:id], comment.merge(
            :access_token => options[:access_token] || self.access_token
          ))
        end
      end

      def comment!(options = {})
        comment = post(options.merge(:connection => :comments))
        Comment.new(comment[:id], options.merge(comment).merge(
          :access_token => options[:access_token] || self.access_token
        ))
      end
    end
  end
end