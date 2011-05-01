module FbGraph
  module Connections
    module Permissions
      def permissions(options = {})
        self.connection(:permissions, options).first.inject([]) do |arr, (key, value)|
          arr << key.to_sym if value.to_i == 1
          arr
        end
      end
    end
  end
end