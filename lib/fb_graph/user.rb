module FbGraph

  class User < Node
    attr_accessor :name, :last_name, :first_name

    def self.me(access_token)
      new('me', :access_token => access_token)
    end

    def profile(options = {})
      if @profile.blank? || options[:force]
        @profile = get(options)
        self.identifier = @profile[:id]
        self.name       = @profile[:name]
        self.last_name  = @profile[:last_name]
        self.first_name = @profile[:first_name]
        self.link       = @profile[:link]
        self
      else
        self
      end
    end

  end

end
