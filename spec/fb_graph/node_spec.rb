require 'spec_helper'

describe FbGraph::Node do

  describe '.new' do
    it 'should setup endpoint' do
      FbGraph::Node.new('matake').endpoint.should == File.join(FbGraph::ROOT_URL, 'matake')
    end

    it 'should support access_token option' do
      FbGraph::Node.new('matake', :access_token => 'access_token').access_token.should == 'access_token'
    end

    it 'should support if_none_match option' do
      FbGraph::Node.new('matake', :if_none_match => 'if_none_match').if_none_match.should == 'if_none_match'
    end

    it 'should support etag option' do
      FbGraph::Node.new('matake', :etag=> 'etag').etag.should == 'etag'
    end
    
    it 'should support status_code option' do
      FbGraph::Node.new('matake', :status_code=> 'status_code').status_code.should == 'status_code'
    end

    it 'should store raw attributes' do
      attributes = {:key => :value}
      FbGraph::Node.new(12345, attributes).raw_attributes.should == attributes
    end
  end
  
  describe '#build_params' do
    let(:node) { node = FbGraph::Node.new('identifier') }
    let(:tmpfile) { Tempfile.new('tmp') }

    it 'should make all values to JSON or String' do
      client = Rack::OAuth2::Client.new(:identifier => 'client_id', :secret => 'client_secret')
      params = node.send :build_params, {:hash => {:a => :b}, :array => [:a, :b], :integer => 123}
      params[:hash].should == '{"a":"b"}'
      params[:array].should == '["a","b"]'
      params[:integer].should == '123'
    end

    it 'should support Rack::OAuth2::AccessToken::Legacy as self.access_token' do
      client = Rack::OAuth2::Client.new(:identifier => 'client_id', :secret => 'client_secret')
      node = FbGraph::Node.new('identifier', :access_token => Rack::OAuth2::AccessToken::Legacy.new(:access_token => 'token'))
      params = node.send :build_params, {}
      params[:access_token].should == 'token'
    end

    it 'should support Rack::OAuth2::AccessToken::Legacy as options[:access_token]' do
      client = Rack::OAuth2::Client.new(:identifier => 'client_id', :secret => 'client_secret')
      params = node.send :build_params, {:access_token => Rack::OAuth2::AccessToken::Legacy.new(:access_token => 'token')}
      params[:access_token].should == 'token'
    end

    it 'should support Tempfile' do
      params = node.send :build_params, :upload => tmpfile
      (tmpfile.equal? params[:upload]).should be_true
      # NOTE: For some reason, below fails with RSpec 2.10.0
      # params[:upload].should == tmpfile
    end

    require 'action_dispatch/http/upload'
    it 'should support ActionDispatch::Http::UploadedFile' do
      upload = ActionDispatch::Http::UploadedFile.new(
        :tempfile => tmpfile
      )
      params = node.send :build_params, :upload => upload
      (params[:upload].equal? tmpfile).should be_true
      # NOTE: For some reason, below fails with RSpec 2.10.0
      # params[:upload].should == tmpfile
    end
  end

 describe '#get' do
  it "should pass If-Not-Match header if provided" do
    stub_request(:get, "https://graph.facebook.com/identifier?access_token=12345")\
      .with(:headers => {'If-None-Match'=>'"54321foo"'}).to_return(:status => 304, :body => "", :headers => {})
      node = FbGraph::Node.fetch('identifier', :access_token => '12345', :if_none_match => '54321foo')
  end

  it "should not pass If-Not-Match header if not provided" do
    stub_request(:get, "https://graph.facebook.com/identifier?access_token=12345")\
      .with(:headers => {}).to_return(:status => 200, :body => '{"data": []}', :headers => {})
      node = FbGraph::Node.fetch('identifier', :access_token => '12345')
  end
 end

  describe '#handle_response' do

   let(:not_modified_response) {
      mock(HTTP::Message, :status => 304, :body => '')
    }
   let(:modified_response) {
        mock(HTTP::Message, :body =>  "{\"key1\":\"12345\"}",
                            :status => 200,
                            :headers => {'ETag' => '5431foobar'}
        )
   }     

    it 'should handle null/false response' do
      node = FbGraph::Node.new('identifier')
      null_response = node.send :handle_response do
        HTTP::Message.new_response 'null'
      end
      null_response.should be_nil
      lambda do
        node.send :handle_response do
          HTTP::Message.new_response 'false'
        end
      end.should raise_error(
        FbGraph::NotFound,
        'Graph API returned false, so probably it means your requested object is not found.'
      )
    end

    it 'should raise FbGraph::Exception for invalid JSON response' do
      node = FbGraph::Node.new('identifier')
      expect do
        node.send :handle_response do
          HTTP::Message.new_response 'invalid'
        end
      end.should raise_error FbGraph::Exception
    end
    
    it 'should set ETag and HTTP Status for reponses with 2xx status' do
      node = FbGraph::Node.new('identifier')
      node.send :handle_response do
        modified_response
      end
      node.etag.should == '5431foobar'
      node.status_code.should == 200
      node.not_modified?.should == false
    end

    it 'should set status_code when status is 304' do
      node = FbGraph::Node.new('identifier')
      node.send :handle_response do
        not_modified_response
      end
      node.status_code.should == 304
      node.not_modified?.should == true
    end
  end

end
