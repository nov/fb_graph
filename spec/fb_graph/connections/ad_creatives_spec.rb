require 'spec_helper'

describe FbGraph::Connections::AdGroups, '#ad_creatives' do
  context 'when included by FbGraph::AdGroup' do
    context 'when access_token is given' do
      it 'should return ad_creatives as FbGraph::AdCreative' do
        mock_graph :get, '22334455/adcreatives', 'ad_groups/ad_creatives/22334455_ad_creatives', :access_token => 'access_token' do
          ad_creatives = FbGraph::AdGroup.new('22334455', :access_token => 'access_token').ad_creatives
          ad_creatives.size.should == 1 
          ad_creative = ad_creatives.first 
          ad_creative.identifier.should == "6003590469668"
          ad_creative.view_tag.should == ""
          ad_creative.alt_view_tags.should == []
          ad_creative.creative_id.should == "6003590469668"
          ad_creative.type.should == 1
          ad_creative.title.should == "Some Creative"
          ad_creative.body.should == "The Body"
          ad_creative.image_hash.should == "4c34b48cdcbf5dd3055acb717343a9d6"
          ad_creative.link_url.should == "http://www.google.com/"
          ad_creative.name.should == "Creative Name"
          ad_creative.run_status.should == 1
          ad_creative.preview_url.should == "http://www.facebook.com/ads/api/creative_preview.php?cid=6003590469668"
          ad_creative.count_current_adgroups.should == 1
          ad_creative.image_url.should == "https://www.google.com/image.png"
        end
      end
    end
  end
end

describe FbGraph::Connections::AdAccounts, '#ad_creatives' do
  context 'when included by FbGraph::AdAccount' do
    context 'when access_token is given' do
      it 'should return ad_creatives as FbGraph::AdCreative' do
        mock_graph :get, 'act_22334455/adcreatives', File.join(MOCK_JSON_DIR, 'ad_accounts/ad_creatives/22334455_ad_creatives.json'), :access_token => 'valid' do
          ad_creatives = FbGraph::AdAccount.new('act_22334455', :access_token => 'valid').ad_creatives
          ad_creatives.size.should == 5 
          ad_creatives.each do |ad_creative|
            ad_creative.should be_instance_of(FbGraph::AdCreative)
          end
        end
      end
    end
  end
end

describe FbGraph::Connections::AdAccounts, 'ad_creative!' do
  context 'when included by FbGraph::AdAccount' do
    context 'when access_token is given' do
      it 'should return ad_creatives as FbGraph::AdCreative' do
        mock_graph :post, 'act_22334455/adcreatives', File.join(MOCK_JSON_DIR, 'ad_creatives/created.json') do
          ad_creative = FbGraph::AdAccount.new('act_22334455', :access_token => 'valid').ad_creative! ( {
            :type => 1,
            :title => "foo",
            :body => "bar",
            :follow_redirect => true,
            :image_hash => "valid_image_hash",
            :link_url => "http://valid.con/link/url"
          })
          ad_creative.should be_instance_of(FbGraph::AdCreative)
        end
      end
    end
  end
end
