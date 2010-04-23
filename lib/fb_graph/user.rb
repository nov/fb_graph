module FbGraph

  class User < Node
    attr_accessor :name, :last_name, :first_name, :about, :birthday, :work, :education, :email, :website

    def self.me(access_token)
      new('me', :access_token => access_token)
    end

    def picture(size = nil)
      picture_endpoint = "#{self.endpoint}/picture"
      if size
        "#{picture_endpoint}?type=#{size}"
      else
        picture_endpoint
      end
    end

    def profile(options = {})
      if @profile.blank? || options[:force]
        @profile = get(options)
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
        # TODO
        self
      else
        self
      end
    end

  end

end
