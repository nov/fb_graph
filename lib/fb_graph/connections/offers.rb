module FbGraph
  module Connections
    module Offers
      def offers(options = {})
        offers = self.connection :offers, options
        offers.map! do |offer|
          Offer.new offer[:id], offer.merge(
            :access_token => options[:access_token] || self.access_token
          )
        end
      end

      def offer!(options = {})
        # A page access token is required to change an associated offer
        offer = post options.merge(:connection => :offers).merge(:access_token => self.page_access_token)
        Offer.new offer[:id], options.merge(offer).merge(
          :access_token => options[:access_token] || self.access_token
        )
      end
    end
  end
end
