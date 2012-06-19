module FbGraph
  module Connections
    module AdConnectionObjects
      def connection_objects(options = {}, &block)
        self.map_connection :connectionobjects, options, AdConnectionObject, &block
      end
    end
  end
end
