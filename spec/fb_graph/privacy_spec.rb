require 'spec_helper'

describe FbGraph::Privacy, '.new' do
  it 'should setup all supported attributes' do
    attributes = {
      :value => 'CUSTOM',
      :friends => 'SOME_FRIENDS',
      :networks => '123,456,789',
      :allow => '999,888,777',
      :deny => '000,111,222'
    }
    privacy = FbGraph::Privacy.new(attributes)
    privacy.value.should    == 'CUSTOM'
    privacy.friends.should  == 'SOME_FRIENDS'
    privacy.networks.should == '123,456,789'
    privacy.allow.should    == '999,888,777'
    privacy.deny.should     == '000,111,222'
  end
end

describe FbGraph::Privacy, '.to_json' do
  it 'should return JSON object' do
    attributes = {
      :value => 'CUSTOM',
      :friends => 'SOME_FRIENDS',
      :networks => '123,456,789',
      :allow => '999,888,777',
      :deny => '000,111,222'
    }
    privacy = FbGraph::Privacy.new(attributes)
    privacy.to_json.should == attributes.to_json
  end
end