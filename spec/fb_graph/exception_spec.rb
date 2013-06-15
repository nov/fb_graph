require 'spec_helper'

describe FbGraph::Exception do
  it 'should properly set its message for inspect' do
    err = FbGraph::Exception.new(400, 'This is the error message')
    err.inspect.should == '#<FbGraph::Exception: This is the error message>'
  end

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

      context "with a variant capitalization of the header" do
        let(:headers) do
          {
            "Www-Authenticate" => 'OAuth "Facebook Platform" "invalid_token" "Invalid OAuth access token."'
          }
        end

        it "should raise an InvalidToken exception" do
          lambda {FbGraph::Exception.handle_httpclient_error(parsed_response, headers)}.should raise_exception(FbGraph::InvalidToken)
        end
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

    context "to an an alias that does not exist" do
      let(:parsed_response) do
        {
          :error => {
            :message => '(#803) Some of the aliases you requested do not exist: test',
            :type => "OAuthException"
          }
        }
      end
      let(:headers) do
        {
          "WWW-Authenticate" =>'OAuth "Facebook Platform" "not_found" "(#803) Some of the aliases you requested do not exist: test"'
        }
      end

      it "should raise a NotFound exception" do
        lambda {FbGraph::Exception.handle_httpclient_error(parsed_response, headers)}.should raise_exception(FbGraph::NotFound)
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

      it "should raise a BadRequest exception" do
        lambda {FbGraph::Exception.handle_httpclient_error(parsed_response, {})}.should raise_exception(FbGraph::BadRequest)
      end

      context "with an Ads API Exception" do
        context "of Could not save creative" do
          let(:parsed_response) do
            {
              :error => {
                :message => 'Could not save creative',
                :type => "Exception"
              }
            }
          end

          it "should raise a CreativeNotSaved exception" do
            lambda {FbGraph::Exception.handle_httpclient_error(parsed_response, {})}.should raise_exception(FbGraph::CreativeNotSaved)
          end
        end

        context "of QueryLockTimeout" do
          let(:parsed_response) do
            {
              :error => {
                :message => 'QueryLockTimeoutException',
                :type => "Exception"
              }
            }
          end

          it "should raise a QueryLockTimeout exception" do
            lambda {FbGraph::Exception.handle_httpclient_error(parsed_response, {})}.should raise_exception(FbGraph::QueryLockTimeout)
          end
        end

        context "of Could not create targeting spec" do
          let(:parsed_response) do
            {
              :error => {
                :message => 'Could not create targeting spec',
                :type => "Exception"
              }
            }
          end

          it "should raise a TargetingSpecNotSaved exception" do
            lambda {FbGraph::Exception.handle_httpclient_error(parsed_response, {})}.should raise_exception(FbGraph::TargetingSpecNotSaved)
          end
        end

        context "of Could not fetch adgroups" do
          let(:parsed_response) do
            {
              :error => {
                :message => 'Could not fetch adgroups',
                :type => "Exception"
              }
            }
          end

          it "should raise a AdgroupFetchFailure exception" do
            lambda {FbGraph::Exception.handle_httpclient_error(parsed_response, {})}.should raise_exception(FbGraph::AdgroupFetchFailure)
          end
        end

        context "of Failed to open process" do
          let(:parsed_response) do
            {
              :error => {
                :message => 'Failed to open process',
                :type => "Exception"
              }
            }
          end

          it "should raise a OpenProcessFailure exception" do
            lambda {FbGraph::Exception.handle_httpclient_error(parsed_response, {})}.should raise_exception(FbGraph::OpenProcessFailure)
          end
        end

        context "of Could not commit transaction" do
          let(:parsed_response) do
            {
              :error => {
                :message => 'Could not commit transaction',
                :type => "Exception"
              }
            }
          end

          it "should raise a TransactionCommitFailure exception" do
            lambda {FbGraph::Exception.handle_httpclient_error(parsed_response, {})}.should raise_exception(FbGraph::TransactionCommitFailure)
          end
        end

        context "of QueryErrorException" do
          let(:parsed_response) do
            {
              :error => {
                :message => 'DB Error: QueryErrorException',
                :type => "Exception"
              }
            }
          end

          it "should raise a QueryError exception" do
            lambda {FbGraph::Exception.handle_httpclient_error(parsed_response, {})}.should raise_exception(FbGraph::QueryError)
          end
        end

        context "of QueryConnectionException" do
          let(:parsed_response) do
            {
              :error => {
                :message => 'QueryConnectionException',
                :type => "Exception"
              }
            }
          end

          it "should raise a QueryConnection exception" do
            lambda {FbGraph::Exception.handle_httpclient_error(parsed_response, {})}.should raise_exception(FbGraph::QueryConnection)
          end
        end

        context "of QueryDuplicateKeyException" do
          let(:parsed_response) do
            {
              :error => {
                :message => 'QueryDuplicateKeyException',
                :type => "Exception"
              }
            }
          end

          it "should raise a QueryDuplicateKey exception" do
            lambda {FbGraph::Exception.handle_httpclient_error(parsed_response, {})}.should raise_exception(FbGraph::QueryDuplicateKey)
          end
        end
      end
    end
    context "with an Exception not containing the error field" do
      let(:parsed_response) do
        {
          :error_code => 1,
          :error_msg => "An unknown error occurred."
        }
      end

      it "should raise an InternalServerError exception" do
        lambda {FbGraph::Exception.handle_httpclient_error(parsed_response, {})}.should raise_exception(FbGraph::InternalServerError)
      end

    end
  end
end
