module FbGraph
  module Connections
    module AdAccounts
      def ad_accounts(options = {})
        ad_accounts = self.connection :adaccounts, options
        ad_accounts.map! do |ad_account|
          AdAccount.new ad_account[:id], ad_account.merge(
            :access_token => options[:access_token] || self.access_token
          )
        end
      end
      
      def ad_account!(options = {})
        ad_account = post options.merge(:connection => :adaccounts)

        ad_account_id = ad_account[:id]

        merged_attrs = options.merge(
          :access_token => options[:access_token] || self.access_token
        )

        if options[:redownload]
          merged_attrs = merged_attrs.merge(ad_account[:data][:adaccounts][ad_account_id]).with_indifferent_access
        end

        AdAccount.new ad_account_id, merged_attrs
      end
    end
  end
end

