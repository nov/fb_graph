module FbGraph
  class Order < Node
    attr_accessor :application, :from, :to, :amount, :status, :country, :created_time, :updated_time

    def initialize(identifier, attributes = {})
      super
      if app = attributes[:application]
        @application = Application.new(app[:id], app)
      end
      if from = attributes[:from]
        @from = User.new(from[:id], from)
      end
      if to = attributes[:to]
        @to = User.new(to[:id], to)
      end
      @status = attributes[:status]
      @country = attributes[:country]
      if attributes[:created_time]
        @created_time = Time.parse(attributes[:created_time]).utc
      end
      if attributes[:updated_time]
        @updated_time = Time.parse(attributes[:updated_time]).utc
      end
    end

    def settled!(options = {})
      update options.merge(:status => :settled)
    end

    def refunded!(message, options = {})
      update options.merge(:status => :refunded, :message => message)
    end

    def canceled!(options = {})
      update options.merge(:status => :canceled)
    end

    def update(attributes = {})
      _attributes_ = attributes.dup
      params = {
        :access_token => self.access_token,
        :status => _attributes_.delete(:status),
        :message => _attributes_.delete(:message),
        :refund_funding_source => _attributes_.delete(:refund_funding_source),
        :refund_reason => _attributes_.delete(:refund_reason),
        :params => _attributes_.to_json
      }
      post params
    end
  end
end
