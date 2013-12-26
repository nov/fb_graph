module FbGraph
  module RequestFilters
    class Debugger
      def filter_request(request)
        started = "======= [FbGraph] API REQUEST STARTED ======="
        log started, request.dump
      end

      def filter_response(request, response)
        finished = "======= [FbGraph] API REQUEST FINISHED ======="
        log '-' * 50, response.dump, finished
      end

      private

      def log(*outputs)
        outputs.each do |output|
          FbGraph.logger.info output
        end
      end
    end
  end
end