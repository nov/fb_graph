require 'spec_helper'

describe FbGraph do
  subject { FbGraph }
  after { FbGraph.debugging = false }

  its(:logger) { should be_a Logger }
  its(:debugging?) { should be_false }

  describe '.debug!' do
    before { FbGraph.debug! }
    its(:debugging?) { should be_true }
  end

  describe '.debug' do
    it 'should enable debugging within given block' do
      FbGraph.debug do
        Rack::OAuth2.debugging?.should be_true
        FbGraph.debugging?.should be_true
      end
      Rack::OAuth2.debugging?.should be_false
      FbGraph.debugging?.should be_false
    end

    it 'should not force disable debugging' do
      Rack::OAuth2.debug!
      FbGraph.debug!
      FbGraph.debug do
        Rack::OAuth2.debugging?.should be_true
        FbGraph.debugging?.should be_true
      end
      Rack::OAuth2.debugging?.should be_true
      FbGraph.debugging?.should be_true
    end
  end

  describe '.http_client' do
    context 'with http_config' do
      before do
        FbGraph.http_config do |config|
          config.ssl_config.verify_mode = OpenSSL::SSL::VERIFY_NONE
          config.connect_timeout = 30
          config.send_timeout    = 40
          config.receive_timeout = 60
        end
      end
      it 'should configure Rack::OAuth2 and FbGraph http_client' do
        [Rack::OAuth2, FbGraph].each do |klass|
          klass.http_client.ssl_config.verify_mode.should == OpenSSL::SSL::VERIFY_NONE
          klass.http_client.connect_timeout.should == 30
          klass.http_client.send_timeout.should    == 40
          klass.http_client.receive_timeout.should == 60
        end
      end
    end
  end
end