module FbGraph
  module Connections
    module Admins
      def admin?(user, options = {})
        admin = self.connection :admins, options.merge(:connection_scope => user.identifier)
        admin.present?
      end
    end
  end
end