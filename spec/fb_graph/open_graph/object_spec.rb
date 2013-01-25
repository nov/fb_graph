require 'spec_helper'

describe FbGraph::OpenGraph::Object do
  subject do
    FbGraph::OpenGraph::Object.new attributes[:id], attributes
  end
  let :attributes do
    MultiJson.load(json).with_indifferent_access
  end

  context 'with play action' do
    let :json do
      <<-JSON
        {
          "url": "http:\/\/samples.ogp.me\/163382137069945",
          "type": "game",
          "title": "Sample Game",
          "image": [{
            "url": "http:\/\/static.ak.fbcdn.net\/images\/devsite\/attachment_blank.png"
          }],
          "description": "",
          "updated_time": "2011-10-10T08:28:48+0000",
          "id": "10150267719331290",
          "application": {
            "id": "115190258555800",
            "name": "Open Graph",
            "url": "http:\/\/www.facebook.com\/apps\/application.php?id=115190258555800"
          }
        }
      JSON
    end
    its(:url) { should == 'http://samples.ogp.me/163382137069945' }
    its(:type) { should == 'game' }
    its(:title) { should == 'Sample Game' }
    its(:image) { should == 'http://static.ak.fbcdn.net/images/devsite/attachment_blank.png' }
    its(:images) { should == ['http://static.ak.fbcdn.net/images/devsite/attachment_blank.png'] }
    its(:description) { should == '' }
    its(:updated_time) { should == Time.parse('2011-10-10T08:28:48+0000') }
    its(:application) do
      should == FbGraph::Application.new(attributes[:application][:id], attributes[:application])
    end
  end

  context 'with custom action' do
    let :json do
      <<-JSON
        {
          "url": "http:\/\/samples.ogp.me\/264755040233381",
          "type": "fbgraphsample:custom_object",
          "title": "Custom Object",
          "image": [{
            "url": "https:\/\/s-static.ak.fbcdn.net\/images\/devsite\/attachment_blank.png"
          }],
          "description": "Custom Object for FbGraph testing",
          "updated_time": "2011-10-26T02:12:08+0000",
          "id": "10150362170052970",
          "application": {
            "id": "134145643294322",
            "name": "gem sample",
            "url": "http:\/\/www.facebook.com\/apps\/application.php?id=134145643294322"
          }
        }
      JSON
    end
    its(:url) { should == 'http://samples.ogp.me/264755040233381' }
    its(:type) { should == 'fbgraphsample:custom_object' }
    its(:title) { should == 'Custom Object' }
    its(:image) { should == 'https://s-static.ak.fbcdn.net/images/devsite/attachment_blank.png' }
    its(:images) { should == ['https://s-static.ak.fbcdn.net/images/devsite/attachment_blank.png'] }
    its(:description) { should == 'Custom Object for FbGraph testing' }
    its(:updated_time) { should == Time.parse('2011-10-26T02:12:08+0000') }
    its(:application) do
      should == FbGraph::Application.new(attributes[:application][:id], attributes[:application])
    end
  end
end