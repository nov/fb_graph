module FbGraph
  module Connections
    module TestUsers
      def test_users(options = {})
        options[:access_token] ||= self.access_token
        test_users = self.connection :accounts, options.merge(:connection_scope => 'test-users')
        test_users.map! do |test_user|
          TestUser.new test_user[:id], test_user
        end
      end

      def test_user!(options = {})
        options[:access_token] ||= self.access_token
        test_user = post options.merge(:connection => :accounts, :connection_scope => 'test-users')
        TestUser.new test_user[:id], test_user
      end
    end
  end
end