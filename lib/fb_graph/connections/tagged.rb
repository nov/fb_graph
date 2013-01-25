module FbGraph
  module Connections
    module Tagged
      def tagged(options = {})
        posts = self.connection :tagged, options
        posts.map! do |post|
          Post.new post[:id], post.merge(
            :access_token => options[:access_token] || self.access_token
          )
        end
      end
    end
  end
end