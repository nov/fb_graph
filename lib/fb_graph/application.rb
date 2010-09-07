module FbGraph
  class Application < Node
    include Connections::Feed
    include Connections::Posts
    include Connections::Picture
    include Connections::Tagged
    include Connections::Links
    include Connections::Photos
    include Connections::Albums
    include Connections::Statuses
    include Connections::Videos
    include Connections::Notes
    include Connections::Events
    include Connections::Subscriptions
    include Connections::Insights

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