module FbGraph
  module Connections
    module AdAccounts
      def ad_accounts(options = {}, &block)
        self.map_connection :adaccounts, options, AdAccount, &block
      end
    end
  end
end
