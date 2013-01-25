require 'spec_helper'

describe FbGraph::AdConnectionObject, '.new' do
  it 'should setup all supported attributes' do
    attributes = {
      :id => 354545238888,
      :name => "MyPage",
      :url => "http://www.facebook.com/MyPage",
      :type => 1,
      :tabs =>
      {
        "http://www.facebook.com/MyPage?sk=wall" => "Wall",
        "http://www.facebook.com/MyPage?sk=info" => "Info",
        "http://www.facebook.com/MyPage?sk=friendactivity" => "Friend Activity",
        "http://www.facebook.com/MyPage?sk=photos" => "Photos",
        "http://www.facebook.com/MyPage?sk=app_2373072222" => "Discussions"
      },
      :picture => "http://profile.ak.fbcdn.net/hprofile-ak-snc4/41591_354545238178_3195000_s.jpg"
    }    
    ad_connection = FbGraph::AdConnectionObject.new(attributes.delete(:id), attributes)
    ad_connection.identifier.should == 354545238888
    ad_connection.name.should == "MyPage"
    ad_connection.url.should == "http://www.facebook.com/MyPage"
    ad_connection.type.should == 1
    ad_connection.should be_page
    ad_connection.object.should be_instance_of(FbGraph::Page)
    ad_connection.object.identifier.should == 354545238888
    ad_connection.picture.should == "http://profile.ak.fbcdn.net/hprofile-ak-snc4/41591_354545238178_3195000_s.jpg"
    ad_connection.tabs.should be_instance_of(Hash)
    ad_connection.tabs["http://www.facebook.com/MyPage?sk=wall"].should == "Wall"
    
    application_attributes = {
        :id => 354545238889, 
        :is_game => false,
        :name => "MyApp", 
        :og_actions => [{
          :connected_objects => ["planes"], 
          :display_name => "Yaw", 
          :name => "app_name_space:yaw", 
          :properties => []
        }], 
        :og_namespace => "app_name_space", 
        :og_objects => [{
          :display_name => "Plane", 
          :name => "planes", 
          :properties => []
        }], 
        :picture => "https://fbcdn-profile-a.akamaihd.net/static-ak/rsrc.php/v1/y0/r/XsEg9L6Ie5_.jpg", 
        :supported_platforms => [2], 
        :tabs => [],
        :type => 2,
        :url => "http://apps.facebook.com/test_app/"
    }
    
    ad_connection = FbGraph::AdConnectionObject.new(application_attributes.delete(:id), application_attributes)
    ad_connection.identifier.should == 354545238889
    ad_connection.is_game.should == false
    ad_connection.name.should == "MyApp"
    ad_connection.og_actions.should be_instance_of(Array)
    ad_connection.og_actions.first.should be_instance_of(Hash)
    ad_connection.og_namespace.should == "app_name_space"
    ad_connection.og_objects.should be_instance_of(Array)
    ad_connection.og_objects.first.should be_instance_of(Hash)    
    ad_connection.object.identifier.should == 354545238889    
    ad_connection.picture.should == "https://fbcdn-profile-a.akamaihd.net/static-ak/rsrc.php/v1/y0/r/XsEg9L6Ie5_.jpg"
    ad_connection.supported_platforms.should == [2]
    ad_connection.tabs.should == []
    ad_connection.type.should == 2
    ad_connection.url.should == "http://apps.facebook.com/test_app/"
  end
end
