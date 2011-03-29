require File.join(File.dirname(__FILE__), '../../spec_helper')

describe FbGraph::Page do
  context 'for people category' do
    before do
      fake_json(:get, 'movie', 'pages/categories/movie')
    end

    let(:page) { FbGraph::Page.new('movie').fetch }
    subject { page }

    [
      :directed_by,
      :genre,
      :plot_outline,
      :produced_by,
      :screenplay_by,
      :starring,
      :studio,
      :written_by
    ].each do |key|
      its(key) { should be_instance_of String }
    end
  end
end