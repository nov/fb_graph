module FbGraph
  class Exception < StandardError
    attr_accessor :code, :type, :message
    def initialize(code, message, body = '')
      @code = code
      if body.blank?
        @message = message
      else
        response = JSON.parse(body).with_indifferent_access
        @message = response[:error][:message]
        @type = response[:error][:type]
      end
    end
  end

  class BadRequest < Exception
    def initialize(message, body = '')
      super 400, message, body
    end
  end

  class Unauthorized < Exception
    def initialize(message, body = '')
      super 401, message, body
    end
  end

  class NotFound < Exception
    def initialize(message, body = '')
      super 404, message, body
    end
  end
end