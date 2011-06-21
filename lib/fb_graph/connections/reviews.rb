module FbGraph
  module Connections
    module Reviews
      def reviews(options = {})
        reviews = self.connection(:reviews, options)
        reviews.map! do |review|
          Review.new(review[:id], review.merge(
            :access_token => options[:access_token] || self.access_token
          ))
        end
      end
    end
  end
end