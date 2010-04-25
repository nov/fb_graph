module FbGraph
  module Connections
    module Tagged
      def tagged(options = {})
        Posts.posts(options.merge(:connection => 'tagged', :self => self))
      end
    end
  end
end