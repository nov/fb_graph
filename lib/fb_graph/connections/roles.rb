module FbGraph
  module Connections
    module Roles
      def roles(options = {})
        roles = self.connection :roles, options
        roles.map! do |role|
          Role.new role
        end
      end

      def admin!(user, options = {})
        role! user, options.merge(:role => 'administrators')
      end

      def developer!(user, options = {})
        role! user, options.merge(:role => 'developers')
      end

      def tester!(user, options = {})
        role! user, options.merge(:role => 'testers')
      end

      def insights_user!(user, options = {})
        role! user, options.merge(:role => 'insights users')
      end

      def role!(user, options = {})
        post options.merge(:user => user.identifier, :connection => :roles)
      end

      def unrole!(user, options = {})
        delete options.merge(:user => user.identifier, :connection => :roles)
      end
    end
  end
end