require 'webmock/rspec'

module WebMockHelper
  def mock_graph(method, path, response_file, options = {})
    stub_request(method, endpoint_for(path)).with(
      request_for(method, options)
    ).to_return(
      response_for(response_file, options)
    )
    yield
    a_request(method, endpoint_for(path)).with(
      request_for(method, options)
    ).should have_been_made.once
    WebMock.reset!
  end

  def request_to(path, method = :get)
    raise_error(WebMock::NetConnectNotAllowedError) { |e|
      e.message.should include("Unregistered request: #{method.to_s.upcase}")
      e.message.should include(endpoint_for path)
    }
  end

  def mock_fql(query, file_path, options = {})
    
  end

  private

  def endpoint_for(path)
    File.join(FbGraph::ROOT_URL, path)
  end

  def request_for(method, options = {})
    request = {}
    if options[:params]
      case method
      when :post, :put
        request[:body] = options[:params]
      else
        request[:query] = options[:params]
      end
    end
    if options[:headers]
      request[:headers] = options[:headers]
    end
    request
  end

  def response_for(response_file, options = {})
    response = {}
    response[:body] = File.new(File.join(File.dirname(__FILE__), '../fake_json', "#{response_file}.json"))
    if options[:status]
      response[:status] = options[:status]
    end
    response
  end
end

include WebMockHelper
WebMock.disable_net_connect!