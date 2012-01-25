module FbGraph
  module Connections
    module AdConnectionObjects
      def connection_objects(options = {})
        connection_objects = self.connection :connectionobjects, options
        connection_objects.map! do |connection_object|
          AdConnectionObject.new connection_object[:id], connection_object.merge(
            :access_token => options[:access_token] || self.access_token
          )
        end
      end
    end
  end
end
