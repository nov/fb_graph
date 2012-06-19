module FbGraph
  module Connections
    module Activities
      def activities(options = {}, &block)
        self.map_connection :activities, options, Page, &block
      end
    end
  end
end
