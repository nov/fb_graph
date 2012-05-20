module FbGraph
  class Role
    include Comparison

    attr_accessor :role, :user, :application

    def initialize(attributes = {})
      @role = attributes[:role]
      @user = User.new attributes[:user]
      @application = Application.new attributes[:app_id]
    end
  end
end