module FbGraph
  module Connections
    module Tagged
      def tagged(options = {})
        posts = get(options.merge(:connection => 'tagged'))
        posts[:data].map! do |post|
          Post.new(post.delete(:id), post)
        end
        Collection.new(posts)
      end
    end
  end
end