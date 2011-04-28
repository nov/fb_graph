require 'webmock/rspec'

module WebMockHelper
  def mock_graph(method, path, response_file, options = {})
    endpoint = File.join(FbGraph::ROOT_URL, path)
    _options_ = options.dup
    _with_ = {}
    if params = _options_.delete(:params)
      case method
      when :post, :put
        _with_[:body] = params
      else
        _with_[:query] = params
      end
    end
    if request_headers = _options_.delete(:headers)
      _with_[:headers] = request_headers
    end
    stub_request(method, endpoint).with(_with_).to_return(
      _options_.merge(
        :body => File.new(File.join(File.dirname(__FILE__), '../fake_json', "#{response_file}.json"))
      )
    )
    yield
    a_request(method, endpoint).with(_with_).should have_been_made.once
  end

  def request_to(method, path)
    
  end

  def mock_fql(query, file_path, options = {})
    
  end
end

include WebMockHelper
WebMock.disable_net_connect!