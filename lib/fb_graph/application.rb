module FbGraph
  class Application < Node
    include Connections::Albums
    include Connections::Events
    include Connections::Feed
    include Connections::Insights
    include Connections::Links
    include Connections::Notes
    include Connections::Photos
    include Connections::Picture
    include Connections::Posts
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

    # == Get OAuth access token
    # 
    # Obtain an OAuth access token associated with your application via the OAuth Client Credentials Flow.
    # 
    # ref) http://developers.facebook.com/docs/api#analytics
    # 
    #   app = FbGraph::Application.new(APP_ID)
    #   app.get_access_token
    #   # => access token as String
    #   app.access_token # once get_access_token is called, access token is cached.
    #   # => access token as String
    # 
    # This method is automatically called when access token needed and application secret has already given.
    # 
    #   app = FbGraph::Application.new(APP_ID, :secret => APP_SECRET)
    #   app.subscriptions # get_access_token is called automatically
    #   # => Array of FbGraph::Subscription
    def get_access_token(secret = nil)
      self.secret ||= secret
      auth = FbGraph::Auth.new(self.identifier, self.secret)
      response_string = auth.client.request(:post, auth.client.access_token_url, {
        :client_id => self.identifier,
        :client_secret => self.secret,
        :type => 'client_cred'
      })
      self.access_token = response_string.split('=').last
    end

  end
end