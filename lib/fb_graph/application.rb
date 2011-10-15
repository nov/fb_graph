module FbGraph
  class Application < Node
    include Connections::Accounts
    include Connections::Achievements
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
    # TODO
    # include Connections::Translations
    include Connections::Videos

    @@attributes = [
      :name,
      :namespace,
      :description,
      :category,
      :company,
      :icon_url,
      :subcategory,
      :link,
      :logo_url,
      :daily_active_users,
      :weekly_active_users,
      :monthly_active_users,
      :secret
    ]
    attr_accessor *@@attributes

    def initialize(client_id, attributes = {})
      super
      @@attributes.each do |key|
        # NOTE:
        # For some reason, Graph API returns daily_active_users, weekly_active_users, monthly_active_users as JSON string.
        value = if [:daily_active_users, :weekly_active_users, :monthly_active_users].include?(key)
          attributes[key].to_i
        else
          attributes[key]
        end
        self.send("#{key}=", value)
      end
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