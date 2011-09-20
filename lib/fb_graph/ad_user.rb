module FbGraph
  class AdUser < User
    attr_accessor :role, :permissions

    def initialize(identifier, attributes = {})
      super(identifier, attributes)

      %w(role permissions).each do |field|
        self.send("#{field}=", attributes[field.to_sym])
      end
    end

    ROLES = {
      :admin        => 1001,
      :general      => 1002,
      :reports_only => 1003
    }
    ROLES.each do |key, value|
      define_method "#{key}_access?" do
        self.role <= value
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
