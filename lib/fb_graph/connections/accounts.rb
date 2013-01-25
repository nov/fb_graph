module FbGraph
  module Connections
    module Accounts
      def accounts(options = {})
        accounts = self.connection :accounts, options
        accounts.map! do |account|
          account[:access_token] ||= options[:access_token] || self.access_token
          case self
          when User
            if account[:category] == 'Application'
              account.delete(:category)
              Application.new account[:id], account
            else
              Page.new account[:id], account
            end
          when Application
            TestUser.new account[:id], account
          end
        end
      end
    end
  end
end