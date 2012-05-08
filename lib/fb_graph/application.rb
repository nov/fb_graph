module FbGraph
  class Application < Node
    include Connections::Accounts
    include Connections::Achievements
    include Connections::Events
    include Connections::Insights
    include Connections::Notes
    include Connections::Payments
    include Connections::Photos
    include Connections::Picture
    include Connections::Subscriptions
    include Connections::TestUsers
    # TODO
    # include Connections::Translations
    include Connections::Videos
    include OpenGraph::ApplicationContext

    @@attributes = [
      :name,
      :namespace,
      :description,
      :canvas_name,
      :category,
      :subcategory,
      :link,
      :company,
      :icon_url,
      :logo_url,
      :daily_active_users,
      :weekly_active_users,
      :monthly_active_users,
      :migrations,
      :namespace,
      :restrictions,
      :app_domains,
      :auth_dialog_data_help_url,
      :auth_dialog_description,
      :auth_dialog_headline,
      :auth_dialog_perms_explanation,
      :auth_referral_user_perms,
      :auth_referral_friend_perms,
      :auth_referral_default_activity_privacy,
      :auth_referral_enabled,
      :auth_referral_extended_perms,
      :auth_referral_response_type,
      :canvas_fluid_height,
      :canvas_fluid_width,
      :canvas_url,
      :contact_email,
      :created_time,
      :creator_uid,
      :deauth_callback_url,
      :iphone_app_store_id,
      :hosting_url,
      :mobile_web_url,
      :page_tab_default_name,
      :page_tab_url,
      :privacy_policy_url,
      :secure_canvas_url,
      :secure_page_tab_url,
      :server_ip_whitelist,
      :social_discovery,
      :terms_of_service_url,
      :user_support_email,
      :user_support_url,
      :website_url,
      :type,
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
        # Boolean fields may be returned as 1 for true or 0 for false
        elsif [:auth_referral_enabled, :canvas_fluid_height, :canvas_fluid_width, :social_discovery]
          if attributes[key] == 1
            true
          elsif attributes[key] == 0
            false
          else
            attributes[key]
          end
        else
          attributes[key]
        end
        self.send("#{key}=", value)
      end
    end

    def get_access_token(secret = nil)
      self.secret ||= secret
      auth = Auth.new(self.identifier, self.secret)
      self.access_token = auth.client.access_token! :client_auth_body
    end

    def access_token_with_auto_fetch
      access_token_without_auto_fetch ||
      self.secret && get_access_token
    end
    alias_method_chain :access_token, :auto_fetch

  end
end
