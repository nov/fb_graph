require 'spec_helper'

describe FbGraph::Connections::Reviews do
  describe "#reviews" do
    it "returns reviews for Facebook Application" do
      mock_graph :get, '2439131959/reviews', 'applications/reviews' do
        app_reviews = FbGraph::Application.new('2439131959').reviews
        app_reviews.class.should == FbGraph::Connection
        app_reviews.each do |review|
          review.should be_instance_of(FbGraph::Review)
        end
      end
    end
  end
end