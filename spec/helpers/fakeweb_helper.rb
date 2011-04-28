require 'fakeweb'

module FakeWebHelper

  def fake_json(method, path, file_path, options = {})
    FakeWeb.register_uri(
      method,
      File.join(FbGraph::ROOT_URL, path),
      options.merge(
        :body => File.read(File.join(File.dirname(__FILE__), '../fake_json', "#{file_path}.json"))
      )
    )
  end

  def _request_to(path, method = :get)
    endpoint = File.join(FbGraph::ROOT_URL, path)
    raise_error(
      FakeWeb::NetConnectNotAllowedError,
      "Real HTTP connections are disabled. Unregistered request: #{method.to_s.upcase} #{endpoint}"
    )
  end

  def fake_fql_json(query, file_path, options = {})
    params = {
      :query => query,
      :access_token => options[:access_token],
      :format => :json
    }
    params.delete_if do |k, v|
      v.blank?
    end
    FakeWeb.register_uri(
      :get,
      FbGraph::Query::ENDPOINT + '?' + params.to_query,
      :body => File.read(File.join(File.dirname(__FILE__), '../fake_json', "#{file_path}.json"))
    )
  end

end

include FakeWebHelper
# FakeWeb.allow_net_connect = false