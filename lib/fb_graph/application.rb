module FbGraph
  class Application < Node
    attr_accessor :auth, :access_token

    def initialize(client_id, client_secret, options = {})
      super(client_id, options)
      @auth = FbGraph::Auth.new(client_id, client_secret, options)
      @access_token = options[:access_token]
    end

    def insights(options = {})
      get_access_token if self.access_token.blank?
      insights = get(:endpoint => File.join(self.endpoint, 'insights')
      puts insights
    end

    def get_access_token(options = {})
      response_string = self.auth.client.request(:post, client.access_token_url, {
        :client_id => self.auth.client.id,
        :client_secret => self.auth.client.secret,
        :type => 'client_cred'
      }.merge(options))
      self.access_token = response_string.split('=').last
    end

  end
end