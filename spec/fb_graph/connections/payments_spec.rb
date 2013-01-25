require 'spec_helper'

describe FbGraph::Connections::Payments do
  describe '#payments' do
    let(:app) { FbGraph::Application.new('app_id', :secret => 'sec sec') }

    it 'should return payments as FbGraph::Order' do
      mock_graph :post, 'oauth/access_token', 'token_response' do
        mock_graph :get, 'app_id/payments', 'applications/payments/sample', :access_token => 'token' do
          app.payments.each do |payment|
            payment.should be_a FbGraph::Order
          end
        end
      end
    end
  end
end
