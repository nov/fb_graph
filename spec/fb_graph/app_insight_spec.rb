require 'spec_helper'

describe FbGraph::AppInsight, '.new' do
  let :attributes do
    {
      :time  => "2015-01-01T08:00:00+0000",
      :value => "5"
    }
  end
  subject { FbGraph::AppInsight.new(attributes) }

  its(:time)  { should == Time.parse(attributes[:time]).utc }
  its(:value) { should == attributes[:value].to_i }
end
