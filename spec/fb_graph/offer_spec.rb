require 'spec_helper'

describe FbGraph::Offer do
  let :attributes do
    {
      :id => '12345',
      :from => {
        :id => '23456',
        :name => 'page_name',
        :category => 'page_cat'
      },
      :title => 'offer 1',
      :created_time => '2011-10-14T21:00:00+0000',
      :expiration_time => '2018-03-15T00:30:00+0000',
      :terms => 'One offer per customer',
      :image_url => 'http://example.org/image.png',
      :coupon_type => 'online_only',
      :claim_limit => 1000,
      :redemption_link => 'http://example.org/redeem'
    }
  end
  let(:offer) { FbGraph::Offer.new(attributes.delete(:id), attributes) }

  describe '.new' do
    it 'should setup all supported attributes' do
      offer.identifier.should == '12345'
      offer.from.should == FbGraph::Page.new('23456', {:name => 'page_name', :category => 'page_cat'})
      offer.title.should == 'offer 1'
      offer.created_time.should == Time.parse('2011-10-14T21:00:00+0000').utc
      offer.expiration_time.should == Time.parse('2018-03-15T00:30:00+0000').utc
      offer.terms.should == 'One offer per customer'
      offer.image_url.should == 'http://example.org/image.png'
      offer.coupon_type.should == 'online_only'
      offer.claim_limit.should == 1000
      offer.redemption_link.should == 'http://example.org/redeem'
      offer.redemption_code.should == nil
    end
  end

  describe '#update' do
    it 'should update existing offer' do
      lambda do
        offer.update(:terms => 'Two offers per customer', :access_token => 'access_token')
      end.should request_to('12345', :post)
    end
  end
end
