require File.join(File.dirname(__FILE__), '../spec_helper')

describe FbGraph::Node, "#initialize" do

  it "should require identifier" do
    lambda do
      FbGraph::Node.new('')
    end.should raise_exception(FbGraph::Node::NotFound)
  end

  it "should setup endpoint" do
    FbGraph::Node.new('matake').endpoint.should == File.join(FbGraph::ROOT_URL, 'matake')
  end

end

describe FbGraph::Node, "#picture" do

  it "should return image url" do
    FbGraph::Node.new('matake').picture.should == File.join(FbGraph::ROOT_URL, 'matake/picture')
  end

  it "should support size option" do
    FbGraph::Node.new('matake').picture(:square).should == File.join(FbGraph::ROOT_URL, 'matake/picture?type=square')
    FbGraph::Node.new('matake').picture(:large).should == File.join(FbGraph::ROOT_URL, 'matake/picture?type=large')
  end

end