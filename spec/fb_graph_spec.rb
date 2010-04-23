require File.join(File.dirname(__FILE__), 'spec_helper')

describe FbGraph, '#node' do
  it "should return FbGraph::Node instance" do
    FbGraph.node('matake').should == FbGraph::Node.new('matake')
  end
end

describe FbGraph, '#user' do

  it "should return FbGraph::User instance" do
    FbGraph.user('matake').should == FbGraph::User.new('matake')
  end

end