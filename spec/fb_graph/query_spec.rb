require 'spec_helper'

describe FbGraph::Query do
  let(:raw_query) { 'SELECT name FROM user WHERE uid = me()' }

  describe '.new' do
    let(:query) { FbGraph::Query.new(raw_query, 'access_token') }

    it 'should setup query and access_token' do
      query.query.should == raw_query
      query.access_token.should == 'access_token'
    end
  end

  describe '.fetch' do
    let(:query) { FbGraph::Query.new(raw_query) }

    context 'when no access token given' do
      it 'should return blank Array' do
        mock_fql raw_query, 'query/user/without_token' do
          response = query.fetch
          response.should == []
        end
      end
    end

    context 'when invalid access token given' do
      it 'should raise exception' do
        mock_fql raw_query, 'query/user/with_invalid_token', :access_token => 'invalid', :status => [400, 'Bad Request'] do
          lambda do
            query.fetch(:access_token => 'invalid')
          end.should raise_error FbGraph::Exception
        end
      end
    end

    context 'when valid access token given' do
      it 'should return an Collection of Hash' do
        mock_fql raw_query, 'query/user/with_valid_token', :access_token => 'valid' do
          response = query.fetch(:access_token => 'valid')
          response.should be_instance_of FbGraph::Collection
          response.should == [{'name' => 'Nov Matake'}]
        end
      end
    end

    context 'with locale option' do
      it 'should support it' do
        mock_fql raw_query, 'query/user/with_valid_token', :access_token => 'valid', :params => {
          :locale => 'ja'
        } do
          query.fetch(:access_token => 'valid', :locale => 'ja')
        end
      end
    end

    context 'when multiquery given' do
      let(:raw_query) do
        {
          :query1 => 'SELECT name FROM user WHERE uid = me()',
          :query2 => 'SELECT name FROM user WHERE uid = me()'
        }
      end

      it 'should return an Hash of Array of Hash' do
        mock_fql raw_query.to_json, 'query/user/multi_query', :access_token => 'valid' do
          response = query.fetch(:access_token => 'valid')
          response.should be_instance_of ActiveSupport::HashWithIndifferentAccess
          response.each do |key, value|
            value.should be_instance_of Array
            value.each do |result|
              result.should be_instance_of ActiveSupport::HashWithIndifferentAccess
            end
          end
          response.should == {
            "query1" => [{"name" => "Nov Matake"}],
            "query2" => [{"name" => "Nov Matake"}]
          }
        end
      end
    end
  end
end