require 'spec_helper'

describe FbGraph::Connections::AdPreviews, '#ad_previews' do
  context 'when included by FbGraph::AdAccount' do
    context 'when access_token is given' do
      it 'should return ad_preview as FbGraph::AdPreview' do
        mock_graph :post, 'act_123456789/adpreviews', 'ad_accounts/ad_previews/test_ad_previews'  do
          ad_account = FbGraph::AdAccount.new('act_123456789', :access_token => 'access_token')
          ad_preview = ad_account.ad_previews(:access_token => 'access_token', :preview_spec => {})
          ad_preview.should be_instance_of(FbGraph::AdPreview)
          ad_preview.preview_data.should == 'hello world'
        end
      end
    end
  end
end


