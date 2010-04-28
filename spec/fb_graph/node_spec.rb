require File.join(File.dirname(__FILE__), '../spec_helper')

describe FbGraph::Node, '#new' do

  it 'should setup endpoint' do
    FbGraph::Node.new('matake').endpoint.should == File.join(FbGraph::ROOT_URL, 'matake')
  end

  it 'should support access_token option' do
    FbGraph::Node.new('matake', :access_token => 'access_token').access_token.should == 'access_token'
  end

end