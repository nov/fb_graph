require 'spec_helper'

describe FbGraph::Page do
  context 'for people category' do
    let :page do
      mock_graph :get, 'movie', 'pages/categories/movie' do
        FbGraph::Page.new('movie').fetch
      end
    end
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