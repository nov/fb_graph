require 'spec_helper'

describe FbGraph::Connections::Picture, '#picture' do

  context 'when included by FbGraph::User' do
    it 'should return image url' do
      FbGraph::User.new('matake').picture.should == File.join(FbGraph::ROOT_URL, 'matake/picture')
    end

    it 'should support size option' do
      [:square, :small, :normal, :large].each do |size|
        FbGraph::User.new('matake').picture(size).should == File.join(FbGraph::ROOT_URL, "matake/picture?type=#{size}")
      end
    end

    it 'should support width option' do
      FbGraph::User.new('matake').picture(13).should == File.join(FbGraph::ROOT_URL, "matake/picture?width=13")
    end

    it 'should support height option' do
      FbGraph::User.new('matake').picture(nil, 37).should == File.join(FbGraph::ROOT_URL, "matake/picture?height=37")
    end

    it 'should support width and height options at the same time' do
      FbGraph::User.new('matake').picture(13, 37).should == File.join(FbGraph::ROOT_URL, "matake/picture?width=13&height=37")
    end
  end

  context 'when included by FbGraph::Page' do
    it 'should return image url' do
      FbGraph::Page.new('platform').picture.should == File.join(FbGraph::ROOT_URL, 'platform/picture')
    end

    it 'should support size option' do
      [:square, :small, :normal, :large].each do |size|
        FbGraph::Page.new('platform').picture(size).should == File.join(FbGraph::ROOT_URL, "platform/picture?type=#{size}")
      end
    end

    it 'should support width option' do
      FbGraph::Page.new('platform').picture(13).should == File.join(FbGraph::ROOT_URL, "platform/picture?width=13")
    end

    it 'should support height option' do
      FbGraph::Page.new('platform').picture(nil, 37).should == File.join(FbGraph::ROOT_URL, "platform/picture?height=37")
    end

    it 'should support width and height options at the same time' do
      FbGraph::Page.new('platform').picture(13, 37).should == File.join(FbGraph::ROOT_URL, "platform/picture?width=13&height=37")
    end    
  end

end