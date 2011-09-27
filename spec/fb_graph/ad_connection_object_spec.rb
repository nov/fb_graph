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
  end
end
