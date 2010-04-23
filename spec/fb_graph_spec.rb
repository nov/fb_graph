require File.join(File.dirname(__FILE__), 'spec_helper')

describe FbGraph, "#node" do
  it "should return FbGraph::Node instance" do
    FbGraph.node('matake').should be_instance_of(FbGraph::Node)
  end
end