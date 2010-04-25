module FbGraph
  module Connections
    module Home
      def home(options = {})
        Posts.posts(options.merge(:connection => 'home', :self => self))
      end
    end
  end
end