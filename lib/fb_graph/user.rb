module FbGraph

  class User < Node
    include Connections::Likes
    include Connections::Picture
    include Connections::Statuses

    attr_accessor :name, :last_name, :first_name, :link, :about, :birthday, :work, :education, :email, :website

    def self.me(access_token)
      new('me', :access_token => access_token)
    end

    def profile(options = {})
      @profile ||= get(options)
      self.identifier = @profile[:id]
      self.name       = @profile[:name]
      self.last_name  = @profile[:last_name]
      self.first_name = @profile[:first_name]
      self.link       = @profile[:link]
      self.about      = @profile[:about]
      self.birthday   = @profile[:birthday]
      self.work       = @profile[:work]
      self.education  = @profile[:education]
      self.email      = @profile[:email]
      self.website    = @profile[:website]
      self
    end

  end

end
