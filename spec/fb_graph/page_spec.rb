require 'spec_helper'

describe FbGraph::Page do
  let(:attributes) do
    {
      :id       => '19292868552',
      :category => 'Technology',
      :likes    => 578246,
      :name     => 'Facebook Platform',
      :username => 'platform',
      :talking_about_count => 3232
    }
  end
  subject do
    FbGraph::Page.new(attributes[:id], attributes)
  end

  its(:identifier)          { should == attributes[:id]       }
  its(:category)            { should == attributes[:category] }
  its(:like_count)          { should == attributes[:likes]    }
  its(:name)                { should == attributes[:name]     }
  its(:username)            { should == attributes[:username] }
  its(:talking_about_count) { should == attributes[:talking_about_count] }

  describe 'link' do
    context 'when username exists' do
      subject { FbGraph::Page.new(attributes[:id], attributes) }
      its(:link) { should == "https://www.facebook.com/#{attributes[:username]}" }
    end

    context 'otherwise' do
      subject { FbGraph::Page.new(attributes[:id]) }
      its(:link) { should == "https://www.facebook.com/#{attributes[:id]}" }
    end
  end

  describe '.fetch' do
    subject do
      mock_graph :get, 'platform', 'pages/platform_public' do
        FbGraph::Page.fetch('platform')
      end
    end
    its(:identifier) { should == '19292868552' }
    its(:name)       { should == 'Facebook Platform' }
    its(:category)   { should == 'Technology' }
    its(:like_count) { should == 578214 }
    its(:talking_about_count) { should == 40945 }

    context 'when access_token field fetched' do
      subject do
        mock_graph :get, 'my_page', 'pages/with_token', :access_token => 'user_token', :params => {
          :fields => :access_token
        } do
          FbGraph::Page.fetch('my_page', :fields => :access_token, :access_token => 'user_token')
        end
      end
      its(:access_token) { should == 'page_token' }
    end
  end
end