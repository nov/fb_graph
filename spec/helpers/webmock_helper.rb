require 'webmock/rspec'

module WebMockHelper
  def mock_graph(method, path, response_file, options = {})
    endpoint = File.join(FbGraph::ROOT_URL, path)
    stub_request(method, endpoint).with(
      request_for(method, options)
    ).to_return(
      response_for(response_file, options)
    )
    yield
    a_request(method, endpoint).with(
      request_for(method, options)
    ).should have_been_made.once
    WebMock.reset!
  end

  def request_to(method, path)
    
  end

  def mock_fql(query, file_path, options = {})
    
  end

  private

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