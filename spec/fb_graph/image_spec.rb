require 'spec_helper'

describe FbGraph::Image, '.new' do
  let :attributes do
    {
      :source => 'https://fbcdn-sphotos-a.akamaihd.net/hphotos-ak-ash1/168119_10150146071831729_20531316728_7844072_5116892_n.jpg',
      :height => 483,
      :width => 720
    }
  end
  subject { FbGraph::Image.new(attributes) }

  its(:source) { should == attributes[:source] }
  its(:height) { should == attributes[:height] }
  its(:width)  { should == attributes[:width]  }
end