module FbGraph
  module Connections
    module ReachEstimates
      def reach_estimates(options = {})
        reach_estimates = self.get options.merge(:connection => :reachestimate)
        ReachEstimate.new reach_estimates.merge(:access_token => options[:access_token] || self.access_token)
      end
    end
  end
end


