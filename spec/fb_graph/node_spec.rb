require File.join(File.dirname(__FILE__), '../spec_helper')

describe FbGraph::Node, '#initialize' do

  it 'should require identifier' do
    lambda do
      FbGraph::Node.new('')
    end.should raise_exception(FbGraph::NotFound)
  end

  it 'should setup endpoint' do
    FbGraph::Node.new('matake').endpoint.should == File.join(FbGraph::ROOT_URL, 'matake')
  end

  it 'should support access_token option' do
    FbGraph::Node.new('matake', :access_token => 'access_token').access_token.should == 'access_token'
  end

end

describe FbGraph::Node, '#picture' do

  it 'should return image url' do
    FbGraph::Node.new('matake').picture.should == File.join(FbGraph::ROOT_URL, 'matake/picture')
  end

  it 'should support size option' do
    [:square, :large].each do |size|
      FbGraph::Node.new('matake').picture(size).should == File.join(FbGraph::ROOT_URL, "matake/picture?type=#{size}")
    end
  end

end