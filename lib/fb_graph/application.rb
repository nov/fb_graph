module FbGraph
  class Application < Node
    include Connections::Accounts
    include Connections::Albums
    include Connections::Events
    include Connections::Feed
    include Connections::Insights
    include Connections::Links
    include Connections::Notes
    include Connections::Payments
    include Connections::Photos
    include Connections::Picture
    include Connections::Posts
    include Connections::Reviews
    include Connections::Statuses
    include Connections::Subscriptions
    include Connections::Tagged
    include Connections::TestUsers
    include Connections::Videos

    attr_accessor :name, :description, :category, :link, :secret

    def initialize(client_id, attributes = {})
      super
      @name         = attributes[:name]
      @description  = attributes[:description]
      @category     = attributes[:category]
      @link         = attributes[:link]
      @secret       = attributes[:secret]
    end

    def get_access_token(secret = nil)
      self.secret ||= secret
      auth = Auth.new(self.identifier, self.secret)
      self.access_token = auth.client.access_token!
    end

    def access_token_with_auto_fetch
      access_token_without_auto_fetch ||
      self.secret && get_access_token
    end
    alias_method_chain :access_token, :auto_fetch

  end
end