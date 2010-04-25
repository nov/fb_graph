module FbGraph
  module Connections
    module Feed
      def feed(options = {})
        Posts.posts(options.merge(:connection => 'feed', :self => self))
      end
    end
  end
end