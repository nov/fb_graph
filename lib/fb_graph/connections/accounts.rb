module FbGraph
  module Connections
    # = What's "accounts"?
    #
    # Pages owned by the current user.
    # Yes, the naming doesn't make sense :(
    #
    # ref) http://developers.facebook.com/docs/api#impersonation
    #
    # = Authentication
    #
    # * Access token is required.
    # * "manage_pages" permission is optional.
    #
    # If the "manage_pages" permission has been granted,
    # this connection also yields access_tokens that can be used to query the Graph API on behalf of the page.
    #
    # ref) http://developers.facebook.com/docs/reference/api/user
    #
    # = Connected with
    #
    # * FbGraph::User
    #
    # == Fetch
    #
    #   pages = FbGraph::User.me(ACCESS_TOKEN).accounts
    #   # => array of FbGraph::Page
    #   pages.first.access_token
    #   # => String if "manage_pages" permission has been granted, nil if not.
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