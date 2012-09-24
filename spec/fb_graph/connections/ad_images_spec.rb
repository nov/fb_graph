require 'spec_helper'

describe FbGraph::Connections::AdImages, '#ad_images' do
  context 'when included by FbGraph::AdAccount' do
    context 'when access_token is given' do
      it 'should return ad_images as FbGraph::AdImage' do
        mock_graph :get, 'act_22334455/adimages', 'ad_accounts/ad_images/22334455_ad_images', :access_token => 'valid' do
          ad_images = FbGraph::AdAccount.new('act_22334455', :access_token => 'valid').ad_images
          ad_images.size.should == 2
          ad_images.each { |ad_image| ad_image.should be_instance_of(FbGraph::AdImage) }
          ad_images.first.should == FbGraph::AdImage.new(
            "0d500843a1d4699a0b41e99f4137a5c3",
            :access_token => "valid",
            :hash => "0d500843a1d4699a0b41e99f4137a5c3",
            :url  => "https://fbcdn-photos-a.akamaihd.net/photos-aksnc1/v41818/flyers/5/36/1314272071984394364_1_88aed216.jpg"
          )
        end
      end
    end
  end
end

describe FbGraph::Connections::AdImages, '#ad_image!' do
  context 'when included by FbGraph::AdAccount' do
    it 'should return generated ad_image' do
      File.stub!(:exist?).and_return(true)
      File.stub!(:open).and_return("foo\nbar\n")
      mock_graph :post, 'act_22334455/adimages', 'ad_accounts/ad_images/post_with_valid_access_token' do
        ad_image = FbGraph::AdAccount.new('act_22334455', :access_token => 'valid').ad_image!(
          :file => "test_image.jpg"
        )

        ad_image.identifier.should == "8cf726a44ab7008c5cc6b4ebd2491234"
        ad_image.hash.should == "8cf726a44ab7008c5cc6b4ebd2491234"
        ad_image.url.should == "https://fbcdn-photos-a.akamaihd.net/photos-ak-snc1/v41818/flyers/19/58/13117189501439916725_1_3b571234.jpg"
      end
    end
  end
end

