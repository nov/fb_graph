describe FbGraph::Page::Categories::LocalBusiness do
  before do
    fake_json(:get, 'local_business', 'pages/categories/local_business')
  end
  subject { FbGraph::Page.new('local_business').fetch }

  [:attire, :culinary_team, :general_manager, :phone, :price_range, :public_transit].each do |key|
    its(key) { should == '' }
  end
end