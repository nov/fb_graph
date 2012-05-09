require 'spec_helper'

describe FbGraph::Connections::Milestones do
  let(:page) do
    FbGraph::Page.new('page_id', :access_token => 'page_token')
  end

  describe '#milestones' do
    it 'should return an Array of FbGraph::Milestone' do
      mock_graph :get, 'page_id/milestones', 'pages/milestones/list', :access_token => 'page_token' do
        milestones = page.milestones
        milestones.should be_instance_of FbGraph::Connection
        milestones.each do |milestone|
          milestone.should be_instance_of FbGraph::Milestone
        end
      end
    end
  end

  describe '#milestone!' do
    it 'should return generated milestone' do
      started_at = 3.years.ago
      mock_graph :post, 'page_id/milestones', 'pages/milestones/created', :access_token => 'page_token', :params => {
        :title => 'Reached 1M users!',
        :description => 'Finally we got 1M-th user!',
        :start_time => started_at.to_s
      } do
        milestone = page.milestone!(
          :title => 'Reached 1M users!',
          :description => 'Finally we got 1M-th user!',
          :start_time => started_at
        )
        milestone.should be_instance_of FbGraph::Milestone
        milestone.title.should       == 'Reached 1M users!'
        milestone.description.should == 'Finally we got 1M-th user!'
        milestone.start_time.should  == started_at
      end
    end
  end
end
