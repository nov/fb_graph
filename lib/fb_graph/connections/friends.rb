module FbGraph
  module Connections
    module Friends
      def friends(options = {}, &block)
        self.map_connection :friends, options, User, &block
      end
    end
  end
end
