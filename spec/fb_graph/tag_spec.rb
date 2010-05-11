require File.join(File.dirname(__FILE__), '../spec_helper')

describe FbGraph::Tag, '.new' do

  it 'should setup all supported attributes' do
    attributes = {
      :id => "7901103",
      :name => "Arjun Banker",
      :x => 32.5,
      :y => 27.7778,
      :created_time => "2010-04-22T08:24:26+0000"
    }
    tag = FbGraph::Tag.new(attributes.delete(:id), attributes)
    tag.user.should == FbGraph::User.new('7901103', :name => "Arjun Banker")
    tag.x.should == 32.5
    tag.y.should == 27.7778
    tag.created_time.should == Time.parse("2010-04-22T08:24:26+0000")
    
  end

end