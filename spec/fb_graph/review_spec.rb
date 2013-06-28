require 'spec_helper'

describe FbGraph::Review do
  describe '.new' do
    let(:attributes) do
      {
        id: '10150326116771960',
        from: {
          name: 'Erin Bennett',
          id: '3326740'
        },
        to: {
          name: 'Graffiti',
          namespace: 'graffitiwall',
          id: '2439131959'
        },
        message: 'awesome!',
        rating: 5,
        created_time: '2011-10-16T06:50:04+0000'
      }
    end
    subject do
      FbGraph::Review.new attributes[:id], attributes
    end

    its(:from) do
      should == FbGraph::User.new('3326740', name: 'Erin Bennett')
    end
    its(:to) do
      should == FbGraph::Application.new('2439131959', name: 'Graffiti', namespace: 'graffitiwall')
    end
    its(:rating)       { should == 5 }
    its(:message)      { should == 'awesome!' }
    its(:created_time) { should == Time.parse('2011-10-16T06:50:04+0000') }
  end
end