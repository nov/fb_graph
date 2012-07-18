require 'spec_helper'

describe FbGraph::Order do
  subject { order }
  let(:order) { FbGraph::Order.new attributes[:id], attributes }
  let :attributes do
    {
      :id => '9005539514450',
      :from => {
        :name => 'Nov Matake',
        :id => '579612276'
      },
      :to => {
        :name => 'Nov Matake',
        :id => '579612276'
      },
      :amount => 2,
      :status => 'settled',
      :application => {
        :name => 'gem sample',
        :id => '134145643294322'
      },
      :created_time => '2011-09-01T04:34:35+0000',
      :updated_time => '2011-09-01T04:34:38+0000'
    }
  end

  its(:identifier)   { should == '9005539514450' }
  its(:from)         { should == FbGraph::User.new('579612276', :name => 'Nov Matake') }
  its(:to)           { should == FbGraph::User.new('579612276', :name => 'Nov Matake') }
  its(:application)  { should == FbGraph::Application.new('134145643294322', :name => 'gem sample') }
  its(:amount)       { should == 2 }
  its(:status)       { should == 'settled' }
  its(:created_time) { should == Time.parse('2011-09-01T04:34:35+0000') }
  its(:updated_time) { should == Time.parse('2011-09-01T04:34:38+0000') }

  describe '#settle!' do
    it do
      expect { order.settle! }.to request_to order.identifier, :post
    end

    it 'I have never succeeded this call yet'
  end

  describe '#refund!' do
    it do
      expect { order.refund! }.to request_to order.identifier, :post
    end

    it 'should return true' do
      mock_graph :post, order.identifier, 'true', :access_token => 'access_token', :params => {
        :status => 'refunded'
      } do
        order.refunded!(:access_token => 'access_token').should be_true
      end
    end
  end

  describe '#cancel!' do
    it do
      expect { order.cancel! }.to request_to order.identifier, :post
    end

    it 'I have never succeeded this call yet'
  end
end