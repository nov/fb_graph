require File.join(File.dirname(__FILE__), '../../spec_helper')

describe FbGraph::Connections::Links, '#links' do
  context 'when included by FbGraph::User' do
    before(:all) do
      fake_json(:get, 'matake/links?access_token=access_token', 'users/links/matake_private')
    end

    it 'should return notes as FbGraph::Link' do
      links = FbGraph::User.new('matake', :access_token => 'access_token').links
      links.each do |link|
        link.should be_instance_of(FbGraph::Link)
      end
    end
  end
end

describe FbGraph::Connections::Links, '#link!' do
  context 'when included by FbGraph::User' do
    before do
      fake_json(:post, 'matake/links', 'users/links/post_with_valid_access_token')
    end

    it 'should return generated link' do
      link = FbGraph::User.new('matake', :access_token => 'valid').link!(
        :link => 'http://github.com/nov/fb_graph',
        :message => 'A Ruby wrapper for Facebook Graph API.'
      )
      link.identifier.should == 120765121284251
      link.link.should == 'http://github.com/nov/fb_graph'
      link.message.should == 'A Ruby wrapper for Facebook Graph API.'
      link.access_token.should == 'valid'
    end
  end
end