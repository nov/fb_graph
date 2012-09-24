require 'spec_helper'

describe FbGraph::AdImage, '.new' do

  it 'should setup all supported attributes' do
    attributes = {
      :hash => 'valid_image_hash',
      :url => "http://valid.image/url.jpg"
    }
    ad_image = FbGraph::AdImage.new(attributes[:hash], attributes)
    ad_image.identifier.should == attributes[:hash]
    ad_image.hash.should == attributes[:hash]
    ad_image.url.should == attributes[:url]
  end
end
