require 'spec_helper'

describe FbGraph::AdCreative, '.new' do

  it 'should setup all supported attributes' do
    attributes = {
      :id => '6003590469668',
      :view_tag => "",
      :alt_view_tags => [],
      :creative_id => "6003590469668",
      :type => 1,
      :title => "Some Creative",
      :body => "The Body",
      :image_hash => "4c34b48cdcbf5dd3055acb717343a9d6",
      :link_url => "http://www.google.com/",
      :name => "Creative Name",
      :run_status => 1,
      :preview_url => "http://www.facebook.com/ads/api/creative_preview.php?cid=6003590469668",
      :count_current_adgroups => 1,
      :object_id => 12345,
      :story_id => 54321,
      :image_url => "https://www.google.com/image.png",
      :url_tags => "url=tags",
      :related_fan_page => 5799040003,
      :auto_update => 1,
      :action_spec => '{"action.type":["flightsim:fly"], "application":[174829001234]}',
      :query_templates => ["6"]
    }
    ad_creative = FbGraph::AdCreative.new(attributes.delete(:id), attributes)
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
    ad_creative.facebook_object_id.should == 12345
    ad_creative.image_url.should == "https://www.google.com/image.png"
    ad_creative.url_tags.should == "url=tags"
    ad_creative.related_fan_page.should == 5799040003
    ad_creative.auto_update.should == 1
    ad_creative.action_spec.should == '{"action.type":["flightsim:fly"], "application":[174829001234]}'
    ad_creative.query_templates.should == ["6"] 
  end
end


 describe FbGraph::AdCreative, '.fetch' do
   it 'should get the ad creative' do
     mock_graph :get, '6003590469668', 'ad_creatives/test_ad_creative', :access_token => 'access_token' do
       ad_creative = FbGraph::AdCreative.fetch('6003590469668', :access_token => 'access_token')
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

 describe FbGraph::AdCreative, '.update' do
   it "should return true from facebook" do 
     mock_graph :post, '6003590469668', 'true', :body => "New Body" do
       attributes = {
         :id => '6003590469668',
         :body => "The Body"
       }
       ad_creative = FbGraph::AdCreative.new(attributes.delete(:id), attributes)
       ad_creative.update(:body => "New Body").should be_true
     end
   end
 end
