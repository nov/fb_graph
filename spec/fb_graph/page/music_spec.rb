require 'spec_helper'

describe FbGraph::Page do
  context 'for music category' do
    before do
      fake_json(:get, 'music', 'pages/categories/music')
    end

    let(:page) { FbGraph::Page.new('music').fetch }
    subject { page }

    [
      :artists_we_like,
      :band_interests,
      :band_members,
      :booking_agent,
      :current_location,
      :influences,
      :press_contact,
      :record_label
    ].each do |key|
      its(key) { should be_instance_of String }
    end
  end
end