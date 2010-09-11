module FbGraph
  module Connections
    # == Fetching Pages owned by the current user.
    # 
    # If the manage_pages permission has been granted,
    # this connection also yields access_tokens that can be used to query the Graph API on behalf of the page.
    # 
    # ref) http://developers.facebook.com/docs/reference/api/user
    # 
    #   FbGraph::User.me(ACCESS_TOKEN).accounts
    #   => array of FbGraph::Page
    module Accounts
      def accounts(options = {})
        accounts = self.connection(:accounts, options)
        accounts.map! do |account|
          account[:access_token] ||= options[:access_token] || self.access_token
          FbGraph::Page.new(account.delete(:id), account)
        end
      end
    end
  end
end