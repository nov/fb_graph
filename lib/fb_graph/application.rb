module FbGraph
  class Application < Node
    include Connections::Insights

    attr_accessor :name, :description, :category, :subcategory, :link, :secret

    def initialize(client_id, options = {})
      super
      @name        = options[:name]
      @description = options[:description]
      @category    = options[:category]
      @subcategory = options[:subcategory]
      @link        = options[:link]
      @secret      = options[:secret]
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