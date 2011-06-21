require 'spec_helper'

describe FbGraph::Connections::Reviews do
  describe '#reviews' do
    it 'should return reviews as FbGraph::Review' do
      mock_graph :get, 'my_app/reviews', 'applications/reviews/public' do
        reviews = FbGraph::Application.new('my_app').reviews
        reviews.each do |review|
          review.should be_instance_of(FbGraph::Review)
        end
      end
    end
  end
end