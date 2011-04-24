require 'spec_helper'

describe FbGraph::Insight, '.new' do

  it 'should setup all supported attributes' do
    attributes = {
      :name => 'name_for_the_stats',
      :period => 'day',
      :values => [{'key1' => 'value2'}, {'key2' => 'value2'}]
    }
    insight = FbGraph::Insight.new('foo/insights/bar', attributes)
    insight.identifier == 'foo/insights/bar'
    insight.period.should == 'day'
    insight.values.should == [{'key1' => 'value2'}, {'key2' => 'value2'}]
    insight.values.first[:key1].should == 'value2'
  end

end