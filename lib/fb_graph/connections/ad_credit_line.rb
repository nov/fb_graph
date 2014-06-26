module FbGraph
  module Connections
    module AdCreditLine
      def ad_credit_line!(options={})
        response = post options.merge(:connection => :adcreditline)
        response && response[:success]
      end
    end
  end
end
