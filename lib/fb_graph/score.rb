module FbGraph
  class Score < Node
    attr_accessor :user, :score, :application, :type

    def initialize(identifier, attributes = {})
      super
      if user = attributes[:user]
        @user = User.new(user[:id], user)
      end
      if app = attributes[:application]
        @application = Application.new(app[:id], app)
      end
      @score = attributes[:score]
      @type = attributes[:type]
    end
  end
end