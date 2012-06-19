module FbGraph
  module Connections
    module Accounts
      def accounts(options = {})
        self.connection :accounts, options do |accounts|
          accounts.map! do |account|
            account[:access_token] ||= options[:access_token] || self.access_token
            case self
            when User
              Page.new account[:id], account
            when Application
              TestUser.new account[:id], account
            end
          end
        end
      end
    end
  end
end
