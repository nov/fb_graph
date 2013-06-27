module FbGraph
  module Connections
    module Reviews
      def reviews(options = {})
        reviews = self.connection :reviews, options
        reviews.map! do |review|
          Review.new review[:id], review
        end
      end
    end
  end
end