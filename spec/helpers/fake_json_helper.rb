module FakeJsonHelper
  def fake_json(method, path, file_path, options = {})
    FakeWeb.register_uri(
      method,
      File.join(FbGraph::ROOT_URL, path),
      options.merge(
        :body => File.read(File.join(File.dirname(__FILE__), '../fake_json', "#{file_path}.json"))
      )
    )
  end
end