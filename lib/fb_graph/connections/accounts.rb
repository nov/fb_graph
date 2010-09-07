module FbGraph
  module Connections
    module Accounts
      def accounts(options = {})
        accounts = self.connection(:accounts, options)
        accounts.map! do |account|
          FbGraph::Page.new(account.delete(:id), account.merge(
            :access_token => options[:access_token] || self.access_token
          ))
        end
      end
    end
  end
end