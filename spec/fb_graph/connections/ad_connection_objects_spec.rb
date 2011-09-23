describe FbGraph::Connections::AdConnectionObjects, '#ad_connection_objects' do
  context 'when included by FbGraph::AdAccount' do
    context 'when access_token is given' do
      it 'should return ad_connection_objects as FbGraph::AdConnectionObject' do
        mock_graph :get, 'act_11223344/connectionobjects', 'ad_accounts/ad_connection_objects/test_connection_objects', :access_token => 'access_token' do
          ad_connections = FbGraph::AdAccount.new("act_11223344", :access_token => 'access_token').connection_objects
          ad_connections.size.should == 3

          ad_connections.first.identifier.should == 354545238888
          ad_connections.first.name.should == "MyPage"
          ad_connections.first.url.should == "http://www.facebook.com/MyPage"
          ad_connections.first.type.should == 1
          ad_connections.first.picture.should == "http://profile.ak.fbcdn.net/hprofile-ak-snc4/41591_354545238178_3195000_s.jpg"
          ad_connections.first.tabs.keys.size.should == 5
          ad_connections.first.tabs["http://www.facebook.com/MyPage?sk=wall"].should == "Wall"
        end
      end
    end
  end
end
