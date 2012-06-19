module FbGraph
  module Connections
    module Admins
      def admin?(user, options = {})
        self.connection :admins, options.merge(:connection_scope => user.identifier) do |admin|
          admin.present?
        end
      end
    end
  end
end
