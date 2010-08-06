module FbGraph
  module Connections
    module Likes
      def likes(options = {})
        likes = self.connection(:likes, options)
        likes.map! do |like|
          Page.new(like.delete(:id), like.merge(
            :access_token => options[:access_token] || self.access_token
          ))
        end
      end

      # NOTE: likes! is defined in fb_graph/connections/comments.rb
    end
  end
end