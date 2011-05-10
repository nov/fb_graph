require 'spec_helper'

describe FbGraph::Connections::Picture, '#picture' do

  context 'when included by FbGraph::User' do
    it 'should return image url' do
      FbGraph::User.new('matake').picture.should == File.join(FbGraph::ROOT_URL, 'matake/picture')
    end
    
    it 'should return access token' do
      FbGraph::User.new('matake', :access_token => '123').picture.should == File.join(FbGraph::ROOT_URL, 'matake/picture?access_token=123')
    end

    it 'should support size option' do
      [:square, :large].each do |size|
        FbGraph::User.new('matake').picture(size).should == File.join(FbGraph::ROOT_URL, "matake/picture?type=#{size}")
      end
    end
    
    it 'should support size option and return access token' do
      [:square, :large].each do |size|
        FbGraph::User.new('matake', :access_token => '123').picture(size).should == File.join(FbGraph::ROOT_URL, "matake/picture?type=#{size}&access_token=123")
      end
    end
  end

  context 'when included by FbGraph::Page' do
    it 'should return image url' do
      FbGraph::Page.new('platform').picture.should == File.join(FbGraph::ROOT_URL, 'platform/picture')
    end
    
    it 'should return access token' do
      FbGraph::Page.new('platform', :access_token => '123').picture.should == File.join(FbGraph::ROOT_URL, 'platform/picture?access_token=123')
    end

    it 'should support size option' do
      [:square, :large].each do |size|
        FbGraph::Page.new('platform').picture(size).should == File.join(FbGraph::ROOT_URL, "platform/picture?type=#{size}")
      end
    end
    
    it 'should support size option and return access token' do
      [:square, :large].each do |size|
        FbGraph::Page.new('platform', :access_token => '123').picture(size).should == File.join(FbGraph::ROOT_URL, "platform/picture?type=#{size}&access_token=123")
      end
    end
  end

end