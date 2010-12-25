require File.join(File.dirname(__FILE__), '../../spec_helper')

describe FbGraph::Query, '.new' do

  before do
    @raw_query = 'SELECT uid FROM user WHERE uid = me()'
    @query = FbGraph::Query.new(@raw_query, 'access_token')
  end

  it 'should setup query and access_token' do
    @query.query.should == @raw_query
    @query.access_token.should == 'access_token'
  end

  it 'should setup proper endpoint' do
    endpoint = @query.send :build_endpoint
    params = {
      :query => @raw_query,
      :format => :json,
      :access_token => 'access_token'
    }
    endpoint.should == "#{FbGraph::Query::ENDPOINT}?#{params.to_query}"
  end

end

describe FbGraph::Query, '.fetch' do

  before do
    @raw_query = 'SELECT uid FROM user WHERE uid = me()'
    @query = FbGraph::Query.new(@raw_query)
  end

  context 'when no access token given' do
    before do
      fake_fql_json @raw_query, 'query/user/without_token'
    end

    it 'should return blank Hash' do
      response = @query.fetch
      response.should == {}
    end
  end

  context 'when invalid access token given' do
    before do
      fake_fql_json @raw_query, 'query/user/with_invalid_token', :access_token => 'invalid'
    end

    it 'should raise exception' do
      lambda do
        @query.fetch('invalid')
      end.should raise_error(FbGraph::Exception)
    end
  end

  context 'when valid access token given' do
    before do
      fake_fql_json @raw_query, 'query/user/with_valid_token', :access_token => 'valid'
    end

    it 'should return an Array of Hash' do
      response = @query.fetch('valid')
      response.should == [{'uid' => 579612276}]
    end
  end

end