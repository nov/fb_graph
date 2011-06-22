require 'webmock/rspec'

module WebMockHelper
  def mock_graph(method, path, response_file, options = {})
    stub_request(method, endpoint_for(path)).with(
      request_for(method, options)
    ).to_return(
      response_for(response_file, options)
    )
    res = yield
    a_request(method, endpoint_for(path)).with(
      request_for(method, options)
    ).should have_been_made.once
    res
  end

  def request_to(path, method = :get)
    raise_error(WebMock::NetConnectNotAllowedError) { |e|
      e.message.should include("Unregistered request: #{method.to_s.upcase}")
      e.message.should include(endpoint_for path)
    }
  end

  def mock_fql(query, response_file, options = {})
    options.merge!(:params => {
      :query => query,
      :format => :json
    })
    stub_request(:get, FbGraph::Query::ENDPOINT).with(
      request_for(:get, options)
    ).to_return(
      response_for(response_file)
    )
    res = yield
    a_request(:get, FbGraph::Query::ENDPOINT).with(
      request_for(:get, options)
    ).should have_been_made.once
    res
  end

  private

  def endpoint_for(path)
    File.join(FbGraph::ROOT_URL, path)
  end

  def request_for(method, options = {})
    request = {}
    if options[:access_token]
      options[:params] ||= {}
      options[:params][:access_token] = options[:access_token].to_s
    end
    if options[:params]
      case method
      when :post, :put
        request[:body] = options[:params]
      else
        request[:query] = options[:params]
      end
    end
    request
  end

  def response_for(response_file, options = {})
    response = {}
    response[:body] = File.new(File.join(File.dirname(__FILE__), '../mock_json', "#{response_file}.json"))
    if options[:status]
      response[:status] = options[:status]
    end
    response
  end
end

include WebMockHelper
WebMock.disable_net_connect!