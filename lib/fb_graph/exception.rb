module FbGraph
  class Exception < StandardError
    attr_accessor :code, :type

    ERROR_HEADER_MATCHERS = {
      /invalid_token/ => "InvalidToken",
      /invalid_request/ => "InvalidRequest"
    }

    ERROR_EXCEPTION_MATCHERS = {
      /Could\snot\ssave\screative/          => "CreativeNotSaved",
      /QueryLockTimeoutException/           => "QueryLockTimeout",
      /Could\snot\screate\stargeting\sspec/ => "TargetingSpecNotSaved",
      /Could\snot\sfetch\sadgroups/         => "AdgroupFetchFailure",
      /Failed\sto\sopen\sprocess/           => "OpenProcessFailure",
      /Could\snot\scommit\stransaction/     => "TransactionCommitFailure",
      /QueryErrorException/                 => "QueryError",
      /QueryConnectionException/            => "QueryConnection",
      /QueryDuplicateKeyException/          => "QueryDuplicateKey"
    }

    def self.handle_httpclient_error(response, headers)
      return nil unless response[:error]

      # Check the WWW-Authenticate header, since it seems to be more standardized than the response
      # body error information.
      if www_authenticate = headers["WWW-Authenticate"]
        # Session expiration/invalidation is very common. Check for that first.
        if www_authenticate =~ /invalid_token/ && response[:error][:message] =~ /session has been invalidated/
          raise InvalidSession.new("#{response[:error][:type]} :: #{response[:error][:message]}")
        end

        ERROR_HEADER_MATCHERS.keys.each do |matcher|
          if matcher =~ www_authenticate
            exception_class = FbGraph::const_get(ERROR_HEADER_MATCHERS[matcher])
            raise exception_class.new("#{response[:error][:type]} :: #{response[:error][:message]}")
          end
        end
      end

      # If we can't match on WWW-Authenticate, use the type
      case response[:error][:type]
      when /OAuth/
        raise Unauthorized.new("#{response[:error][:type]} :: #{response[:error][:message]}")
      else
        exception_class = nil
        ERROR_EXCEPTION_MATCHERS.keys.each do |matcher|
          exception_class = FbGraph::const_get(ERROR_EXCEPTION_MATCHERS[matcher]) if matcher =~ response[:error][:message]
        end
        if exception_class
          raise exception_class.new("#{response[:error][:type]} :: #{response[:error][:message]}")
        else
          raise BadRequest.new("#{response[:error][:type]} :: #{response[:error][:message]}")
        end
      end
    end

    def initialize(code, message, body = '')
      @code = code
      if body.present?
        response = JSON.parse(body).with_indifferent_access
        message = response[:error][:message]
        @type = response[:error][:type]
      end
      super message
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

  class InternalServerError < Exception
    def initialize(message, body = '')
      super 500, message, body
    end
  end

  class InvalidToken < Unauthorized; end

  class InvalidSession < InvalidToken; end

  class InvalidRequest < BadRequest; end

  class CreativeNotSaved < InternalServerError; end

  class QueryLockTimeout < InternalServerError; end

  class TargetingSpecNotSaved < InternalServerError; end

  class AdgroupFetchFailure < InternalServerError; end

  class OpenProcessFailure < InternalServerError; end

  class TransactionCommitFailure < InternalServerError; end

  class QueryError < InternalServerError; end

  class QueryConnection < InternalServerError; end

  class QueryDuplicateKey < InternalServerError; end
end
