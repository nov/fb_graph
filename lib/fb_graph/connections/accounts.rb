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
    #
    # = Notes
    #
    # == Access token of the page
    #
    # Using given access token, you can do those things as the page, not as yourself.
    #
    # * update the page's wall
    # * create new page's album and upload photos into it
    # * create and manage an event
    # * etc.
    #
    #   page = FbGraph::User.me(ACCESS_TOKEN).accounts.first
    #   page.access_token
    #   # => given because "manage_pages" permission has been granted.
    #   page.feed!(:message => 'Updating via FbGraph')
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