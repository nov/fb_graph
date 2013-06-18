module FbGraph
  class Exception < StandardError
    attr_accessor :status, :type, :error_code, :error_subcode
    alias_method :code, :status

    class << self
      def handle_structured_response(status, details, headers)
        if (error = details[:error])
          klass = klass_for_header(headers, error) || klass_for_structured_body(error)
          message = [error[:type], error[:message]].join(' :: ')
          if klass
            raise klass.new(message, details)
          else
            handle_response status, message, details
          end
        else
          message = [details[:error_code], details[:error_msg]].compact.join(' :: ')
          handle_response status, message, details
        end
      end

      def handle_response(status, message, details = {})
        klass = klass_for_status status
        exception = if klass
          klass.new message, details
        else
          Exception.new status, message, details
        end
        raise exception
      end

      def klass_for_status(status)
        case status
        when 400
          BadRequest
        when 401
          Unauthorized
        when 404
          NotFound
        when 500
          InternalServerError
        end
      end

      def klass_for_header(headers, error)
        key, value = headers.detect do |name, value|
          name.upcase == "WWW-Authenticate".upcase
        end || return
        if value =~ /invalid_token/ && error[:message] =~ /session has been invalidated/
          InvalidSession
        else
          matched, klass = ERROR_HEADER_MATCHERS.detect do |matcher, klass_name|
            matcher =~ value
          end || return
          klass
        end
      end

      def klass_for_structured_body(error)
        case error[:type]
        when /OAuth/
          Unauthorized
        else
          matched, klass = ERROR_EXCEPTION_MATCHERS.detect do |matcher, klass_name|
            matcher =~ error[:message]
          end || return
          klass
        end
      end
    end

    def initialize(status, message, details = {})
      @status = status
      if (error = details.try(:[], :error))
        @type          = error[:type]
        @error_code    = error[:code]
        @error_subcode = error[:error_subcode]
      end
      super message
    end
  end

  class BadRequest < Exception
    def initialize(message, details = {})
      super 400, message, details
    end
  end

  class Unauthorized < Exception
    def initialize(message, details = {})
      super 401, message, details
    end
  end

  class NotFound < Exception
    def initialize(message, details = {})
      super 404, message, details
    end
  end

  class InternalServerError < Exception
    def initialize(message, details = {})
      super 500, message, details
    end
  end

  class InvalidToken             < Unauthorized; end
  class InvalidSession           < InvalidToken; end
  class InvalidRequest           < BadRequest;   end
  class CreativeNotSaved         < InternalServerError; end
  class QueryLockTimeout         < InternalServerError; end
  class TargetingSpecNotSaved    < InternalServerError; end
  class AdgroupFetchFailure      < InternalServerError; end
  class OpenProcessFailure       < InternalServerError; end
  class TransactionCommitFailure < InternalServerError; end
  class QueryError               < InternalServerError; end
  class QueryConnection          < InternalServerError; end
  class QueryDuplicateKey        < InternalServerError; end

  ERROR_HEADER_MATCHERS = {
    /not_found/       => NotFound,
    /invalid_token/   => InvalidToken,
    /invalid_request/ => InvalidRequest
  }

  ERROR_EXCEPTION_MATCHERS = {
    /Could\snot\ssave\screative/          => CreativeNotSaved,
    /QueryLockTimeoutException/           => QueryLockTimeout,
    /Could\snot\screate\stargeting\sspec/ => TargetingSpecNotSaved,
    /Could\snot\sfetch\sadgroups/         => AdgroupFetchFailure,
    /Failed\sto\sopen\sprocess/           => OpenProcessFailure,
    /Could\snot\scommit\stransaction/     => TransactionCommitFailure,
    /QueryErrorException/                 => QueryError,
    /QueryConnectionException/            => QueryConnection,
    /QueryDuplicateKeyException/          => QueryDuplicateKey
  }
end