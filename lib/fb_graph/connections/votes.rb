module FbGraph
  module Connections
    module Votes
      def votes(options = {})
        self.connection :votes, options
      end
    end
  end
end
