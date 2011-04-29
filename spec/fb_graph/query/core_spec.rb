require 'spec_helper'

describe FbGraph::Query do
  let(:raw_query) { 'SELECT uid FROM user WHERE uid = me()' }

  describe '.new' do
    let(:query) { FbGraph::Query.new(raw_query, 'access_token') }

    it 'should setup query and access_token' do
      query.query.should == raw_query
      query.access_token.should == 'access_token'
    end

    it 'should setup proper endpoint' do
      endpoint = query.send :build_endpoint
      params = {
        :query => raw_query,
        :format => :json,
        :access_token => 'access_token'
      }
      endpoint.should == "#{FbGraph::Query::ENDPOINT}?#{params.to_query}"
    end
  end

  describe '.fetch' do
    let(:query) { FbGraph::Query.new(raw_query) }

    context 'when no access token given' do
      it 'should return blank Hash' do
        mock_fql raw_query, 'query/user/without_token' do
          response = query.fetch
          response.should == {}
        end
      end
    end

    context 'when invalid access token given' do
      it 'should raise exception' do
        mock_fql raw_query, 'query/user/with_invalid_token', :access_token => 'invalid' do
          lambda do
            query.fetch('invalid')
          end.should raise_error(FbGraph::Exception)
        end
      end
    end

    context 'when valid access token given' do
      it 'should return an Array of Hash' do
        mock_fql raw_query, 'query/user/with_valid_token', :access_token => 'valid' do
          response = query.fetch('valid')
          response.should == [{'uid' => 579612276}]
        end
      end
    end
  end
end