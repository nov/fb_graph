require 'spec_helper'

class Klass1
  include FbGraph::Serialization
  attr_accessor :att1, :att2
end

class Klass2 < Klass1
  def to_hash(options = {})
    {:att1 => self.att1, :att2 => self.att2}
  end
end

describe FbGraph::Serialization do
  before do
    @node1 = Klass1.new
    @node2 = Klass2.new
    @node1.att1 = "hello"
    @node2.att1 = "hello"
  end

  it 'should require to_hash' do
    lambda do
      @node1.to_json
    end.should raise_error(StandardError, 'Define Klass1#to_hash!')
    @node2.to_hash == {:att1 => 'hello', :att2 => nil}
    @node2.to_json == {:att1 => 'hello'}.to_json
  end
end