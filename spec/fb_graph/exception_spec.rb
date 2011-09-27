require 'spec_helper'

describe FbGraph::Exception do
  context 'when response body is given' do
    it 'should setup message and type from error' do
      err = FbGraph::Exception.new(400, 'This is the original message', {
        :error => {
          :type => 'SomeError',
          :message => 'This is the error message'
        }
      }.to_json)
      err.code.should == 400
      err.type.should == 'SomeError'
      err.message.should == 'This is the error message'
    end
  end

  context 'when response body is not given' do
    it 'should not have type' do
      err = FbGraph::Exception.new(400, 'This is the original message')
      err.code.should == 400
      err.type.should be_nil
      err.message.should == 'This is the original message'
    end
  end
end

describe FbGraph::BadRequest do
  it 'should have 400 status code' do
    err = FbGraph::BadRequest.new 'Bad Request'
    err.code.should == 400
  end
end

describe FbGraph::Unauthorized do
  it 'should have 401 status code' do
    err = FbGraph::Unauthorized.new 'Unauthorized'
    err.code.should == 401
  end
end

describe FbGraph::NotFound do
  it 'should have 404 status code' do
    err = FbGraph::NotFound.new 'Not Found'
    err.code.should == 404
  end
end

describe FbGraph::Exception, ".handle_httpclient_error" do
  context "when WWW-Authenticate header is present" do
    context "with an expired access token" do
      let(:parsed_response) do
        {
          :error => {
            :message => "Error validating access token: The session has been invalidated because the user has changed the password.",
            :type => "OAuthException"
          }
        }
      end
      let(:headers) do
        {
          "WWW-Authenticate" => 'OAuth "Facebook Platform" "invalid_token" "Error validating access token: The session has been invalidated because the user has changed the password.'
        }
      end

      it "should raise an InvalidSession exception" do
        lambda {FbGraph::Exception.handle_httpclient_error(parsed_response, headers)}.should raise_exception(FbGraph::InvalidSession)
      end
    end

    context "with an invalid access token" do
      let(:parsed_response) do
        {
          :error => {
            :message => 'Invalid OAuth access token.',
            :type => "OAuthException"
          }
        }
      end
      let(:headers) do
        {
          "WWW-Authenticate" => 'OAuth "Facebook Platform" "invalid_token" "Invalid OAuth access token."'
        }
      end

      it "should raise an InvalidToken exception" do
        lambda {FbGraph::Exception.handle_httpclient_error(parsed_response, headers)}.should raise_exception(FbGraph::InvalidToken)
      end
    end

    context "with an invalid request" do
      let(:parsed_response) do
        {
          :error => {
            :message => '(#100) Must include the \"campaign_id\" index',
            :type => "OAuthException"
          }
        }
      end
      let(:headers) do
        {
          "WWW-Authenticate" =>'OAuth "Facebook Platform" "invalid_request" "(#100) Must include the \"campaign_id\" index"'
        }
      end

      it "should raise an InvalidRequest exception" do
        lambda {FbGraph::Exception.handle_httpclient_error(parsed_response, headers)}.should raise_exception(FbGraph::InvalidRequest)
      end
    end
  end

  context "without the WWW-Authenticate header" do
    context "with an OAuthException" do
      let(:parsed_response) do
        {
          :error => {
            :message => 'Some kind of OAuthException',
            :type => "OAuthException"
          }
        }
      end

      it "should raise an Unauthorized exception" do
        lambda {FbGraph::Exception.handle_httpclient_error(parsed_response, {})}.should raise_exception(FbGraph::Unauthorized)
      end
    end

    context "with an Exception" do
      let(:parsed_response) do
        {
          :error => {
            :message => 'Some kind of Exception',
            :type => "Exception"
          }
        }
      end

      it "should raise a BadRequst exception" do
        lambda {FbGraph::Exception.handle_httpclient_error(parsed_response, {})}.should raise_exception(FbGraph::BadRequest)
      end
    end
  end
end
