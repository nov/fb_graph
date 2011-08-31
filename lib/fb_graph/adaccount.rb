module FbGraph
  class AdAccount < Node
    attr_accessor :account_id, :name, :account_status, :daily_spend_limit, :users, :currency, :timezone_id, :timezone_name, :capabilities, :account_groups

    def initialize(identifier, attributes = {})
      super

      if (users = attributes[:users])
        @users = users.collect {|u| User.new(u[:uid], u)}
      end

      # if (owner = attributes[:owner])
      #   @owner = User.new(owner[:id], owner)
      # end
      @name           = attributes[:name]
      @account_id = attributes[:account_id]
      @account_status = attributes[:account_status]
      @daily_spend_limit         = attributes[:daily_spend_limit]
      @currency        = attributes[:currency]
      @timezone_id         = attributes[:timezone_id]
      @timezone_name         = attributes[:timezone_name]
    end
  end
end
