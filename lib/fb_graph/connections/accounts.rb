module FbGraph
  module Connections
    module Accounts
      def accounts(options = {})
        accounts = self.connection(:accounts, options)
        accounts.map! do |account|
          account[:access_token] ||= options[:access_token] || self.access_token
          Page.new(account.delete(:id), account)
        end
      end
    end
  end
end