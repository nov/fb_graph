module FbGraph
  class AdUser < User
    attr_accessor :role, :permissions

    def initialize(identifier, attributes = {})
      super(identifier, attributes)

      %w(role permissions).each do |field|
        self.send("#{field}=", attributes[field.to_sym])
      end
    end

    # Level 1001, administrator access
    # Level 1002, general-user (ad manager) access
    # Level 1003, reports-only access
    ROLES = {
      :admin        => 1001,
      :general      => 1002,
      :reports_only => 1003
    }
    ROLES.each do |key, value|
      define_method "#{key}_access?" do
        self.role == value
      end
    end

    # 1: ACCOUNT_ADMIN: modify the set of users associated with the given account.
    # 2: ADMANAGER_READ: view campaigns and ads
    # 3: ADMANAGER_WRITE: manage campaigns and ads
    # 4: BILLING_READ: view account billing information
    # 5: BILLING_WRITE: modify the account billing information
    # 7: REPORTS: run reports
    PERMISSIONS = {
      :account_admin => 1,
      :ad_manager_read => 2,
      :ad_manager_write => 3,
      :billing_read => 4,
      :billing_write => 5,
      # what's "6"??
      :reports => 7
    }
    PERMISSIONS.each do |key, value|
      define_method "#{key}_access?" do
        self.permissions.include? value
      end
    end

    # FbGraph::User#fetch does not retrieve the permissions and roles since they are outside the normal
    # attributes for an FbGraph::User, so we just copy them over from this object before returning
    # the fetched one.
    def fetch(options = {})
      super(options).tap do |fetched|
        fetched.role = role
        fetched.permissions = permissions
      end
    end
  end
end
