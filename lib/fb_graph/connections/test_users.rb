module FbGraph
  module Connections
    module TestUsers
      def test_users(options = {})
        test_users = self.connection(:accounts, options.merge(:connection_scope => 'test-users'))
        test_users.map! do |test_user|
          TestUser.new(test_user.delete(:id), test_user)
        end
      end

      def test_user!(options = {})
        test_user = post(options.merge(:connection => :accounts, :connection_scope => 'test-users'))
        TestUser.new(test_user.delete(:id), test_user)
      end

      def test_friend!(test_user)
        post(options.merge(:connection => :friends, :connection_scope => test_user.identifier))
        test_user.send(:post, options.merge(:connection => :friends, :connection_scope => self.identifier))
      end
    end
  end
end