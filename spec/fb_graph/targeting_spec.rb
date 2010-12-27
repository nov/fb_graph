require File.join(File.dirname(__FILE__), '../spec_helper')

describe FbGraph::Targeting, '.new' do
  it 'should setup all supported attributes' do
    attributes = {
      :country => 'jp',
      :city    => 'Tokyo',
      :region  => 'Tokyo',
      :locale  => 9
    }
    targeting = FbGraph::Targeting.new(attributes)
    targeting.country.should == 'jp'
    targeting.city.should    == 'Tokyo'
    targeting.region.should  == 'Tokyo'
    targeting.locale.should  == 9
  end
end

describe FbGraph::Targeting, '.to_json' do
  it 'should return JSON object' do
    attributes = {
      :country => 'jp',
      :city    => 'Tokyo',
      :locale  => 9,
      :region  => 'Tokyo'
    }
    targeting = FbGraph::Targeting.new(attributes)
    targeting.to_json.should == "{\"country\":\"jp\",\"city\":\"Tokyo\",\"locale\":9,\"region\":\"Tokyo\"}"
  end
end