module FbGraph
  module Connections
    module Posts
      def posts(options = {})
        options[:connection] ||= 'posts'
        __self__ = options.delete(:self) || self
        posts = Collection.new(__self__.send(:get, options))
        posts.map! do |post|
          Post.new(post.delete(:id), post)
        end
      end
      module_function :posts
    end
  end
end