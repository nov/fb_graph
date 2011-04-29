require 'spec_helper'

describe FbGraph::Page do
  let(:attributes) do
    {
      :id       => '19292868552',
      :category => 'Technology',
      :likes    => 578246,
      :name     => 'Facebook Platform',
      :username => 'platform'
    }
  end
  subject do
    FbGraph::Page.new(attributes[:id], attributes)
  end

  its(:identifier) { should == attributes[:id]       }
  its(:category)   { should == attributes[:category] }
  its(:like_count) { should == attributes[:likes]    }
  its(:name)       { should == attributes[:name]     }
  its(:username)   { should == attributes[:username] }

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
  end
end