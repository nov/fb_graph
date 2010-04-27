module FbGraph
  module Connections
    module Comments
      def comments(options = {})
        comments = FbGraph::Collection.new(get(options.merge(:connection => 'comment')))
        comments.map! do |comment|
          Comment.new(comment.delete(:id), comment)
        end
      end
    end
  end
end