require 'spec_helper'

describe FbGraph::Video, '.new' do

  it 'should setup all supported attributes' do
    mock_graph :get, 'video', 'videos/private', :access_token => 'access_token' do
      video = FbGraph::Video.new('video', :access_token => 'access_token').fetch
      video.from.should be_a FbGraph::User
      video.tags.should be_a Array
      video.tags.each do |tag|
        tag.should be_a FbGraph::Tag
      end
      [:name, :description, :embed_html, :icon, :source].each do |attribute|
        video.send(attribute).should be_a String
      end
      [:created_time, :updated_time].each do |attribute|
        video.send(attribute).should be_a Time
      end
    end
  end

  it 'should support page as from' do
    page_video = FbGraph::Video.new('12345', :from => {
      :id => '23456',
      :name => 'Smart.fm',
      :category => 'Web Site'
    })
    page_video.from.should == FbGraph::Page.new('23456', :name => 'Smart.fm', :category => 'Web Site')
  end

end