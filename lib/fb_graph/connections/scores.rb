module FbGraph
  module Connections
    module Scores
      def scores(options = {})
        scores = self.connection :scores, options
        scores.map! do |score|
          Score.new score[:id], score.merge(
            :access_token => options[:access_token] || self.access_token
          )
        end
      end

      def score!(score, options = {})
        post options.merge(:connection => :scores, :score => score)
      end

      def unscore!(options = {})
        destroy options.merge(:connection => :scores)
      end
    end
  end
end