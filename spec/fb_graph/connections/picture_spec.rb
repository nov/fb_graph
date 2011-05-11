require 'spec_helper'

describe FbGraph::Connections::Picture, '#picture' do

  context 'when included by FbGraph::User' do
    it 'should return image url' do
      FbGraph::User.new('matake').picture.should == File.join(FbGraph::ROOT_URL, 'matake/picture')
    end

    it 'should support size option' do
      [:square, :large].each do |size|
        FbGraph::User.new('matake').picture(size).should == File.join(FbGraph::ROOT_URL, "matake/picture?type=#{size}")
      end
    end
  end

  context 'when included by FbGraph::Page' do
    it 'should return image url' do
      FbGraph::Page.new('platform').picture.should == File.join(FbGraph::ROOT_URL, 'platform/picture')
    end

    it 'should support size option' do
      [:square, :large].each do |size|
        FbGraph::Page.new('platform').picture(size).should == File.join(FbGraph::ROOT_URL, "platform/picture?type=#{size}")
      end
    end
  end

end