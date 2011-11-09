module FbGraph
  module Connections
    module Votes
      def users_votes(options = {})
        self.connection(:votes, options)
      end
    end
  end
end
