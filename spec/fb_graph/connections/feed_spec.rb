require 'spec_helper'

describe FbGraph::Connections::Feed, '#feed' do
  context 'when included by FbGraph::User' do
    context 'when no access_token given' do
      it 'should return public posts on the user\'s wall as FbGraph::Post' do
        mock_graph :get, 'arjun/feed', 'users/feed/arjun_public' do
          posts = FbGraph::User.new('arjun').feed
          posts.first.should == FbGraph::Post.new(
            '7901103_121392141207495',
            :from => {
              :id => '7901103',
              :name => 'Arjun Banker'
            },
            :picture => 'http://external.ak.fbcdn.net/safe_image.php?d=d2cc5beedaa401ba54eccc9014647285&w=130&h=130&url=http%3A%2F%2Fimages.ted.com%2Fimages%2Fted%2F269_389x292.jpg',
            :link => 'http://www.ted.com/talks/wade_davis_on_endangered_cultures.html',
            :name => 'Wade Davis on endangered cultures | Video on TED.com',
            :caption => 'www.ted.com',
            :description => 'TED Talks With stunning photos and stories, National Geographic Explorer Wade Davis celebrates the extraordinary diversity of the world\'s indigenous cultures, which are disappearing from the planet at an alarming rate.',
            :icon => 'http://static.ak.fbcdn.net/rsrc.php/z9XZ8/hash/976ulj6z.gif',
            :created_time => '2010-04-25T04:05:32+0000',
            :updated_time => '2010-04-25T04:05:32+0000',
            :privacy => {
              :value => 'EVERYONE'
            }
          )
          posts.each do |post|
            post.should be_instance_of(FbGraph::Post)
          end
        end
      end
    end

    context 'when access_token is given' do
      it 'should return posts on the user\'s wall as FbGraph::Post' do
        mock_graph :get, 'arjun/feed', 'users/feed/arjun_private', :access_token => 'access_token' do
          posts = FbGraph::User.new('arjun').feed(:access_token => 'access_token')
          posts.first.should == FbGraph::Post.new(
            '7901103_121392141207495',
            :access_token => 'access_token',
            :from => {
              :id => '7901103',
              :name => 'Arjun Banker'
            },
            :picture => 'http://external.ak.fbcdn.net/safe_image.php?d=d2cc5beedaa401ba54eccc9014647285&w=130&h=130&url=http%3A%2F%2Fimages.ted.com%2Fimages%2Fted%2F269_389x292.jpg',
            :link => 'http://www.ted.com/talks/wade_davis_on_endangered_cultures.html',
            :name => 'Wade Davis on endangered cultures | Video on TED.com',
            :caption => 'www.ted.com',
            :description => 'TED Talks With stunning photos and stories, National Geographic Explorer Wade Davis celebrates the extraordinary diversity of the world\'s indigenous cultures, which are disappearing from the planet at an alarming rate.',
            :icon => 'http://static.ak.fbcdn.net/rsrc.php/z9XZ8/hash/976ulj6z.gif',
            :created_time => '2010-04-25T04:05:32+0000',
            :updated_time => '2010-04-25T04:05:32+0000',
            :privacy => {
              :value => 'EVERYONE'
            }
          )
          posts.each do |post|
            post.should be_instance_of(FbGraph::Post)
          end
        end
      end
    end
  end
end

describe FbGraph::Connections::Feed, '#feed!' do
  context 'when included by FbGraph::User' do
    context 'when no access_token given' do
      it 'should raise FbGraph::Exception' do
        mock_graph :post, 'matake/feed', 'users/feed/post_without_access_token', :status => [500, 'Internal Server Error'] do
          lambda do
            FbGraph::User.new('matake').feed!(:message => 'hello')
          end.should raise_exception(FbGraph::Exception)
        end
      end
    end

    context 'when invalid access_token is given' do
      it 'should raise FbGraph::Exception' do
        mock_graph :post, 'matake/feed', 'users/feed/post_with_invalid_access_token', :status => [500, 'Internal Server Error'] do
          lambda do
            FbGraph::User.new('matake', :access_token => 'invalid').feed!(:message => 'hello')
          end.should raise_exception(FbGraph::Exception)
        end
      end
    end

    context 'when valid access_token is given' do
      it 'should return generated post' do
        mock_graph :post, 'matake/feed', 'users/feed/post_with_valid_access_token' do
          post = FbGraph::User.new('matake', :access_token => 'valid').feed!(:message => 'hello')
          post.identifier.should == '579612276_401071652276'
          post.message.should == 'hello'
          post.access_token.should == 'valid'
        end
      end
    end

    context 'when place is given as page_id' do
      it 'should have Place' do
        mock_graph :post, 'matake/feed', 'users/feed/post_with_valid_access_token', :access_token => 'access_token', :params => {
          :message => 'hello',
          :place => 'place_page_id'
        } do
          post = FbGraph::User.new('matake', :access_token => 'access_token').feed!(:message => 'hello', :place => 'place_page_id')
          post.place.should == FbGraph::Page.new('place_page_id')
        end
      end
    end

    context 'when place is given as FbGraph::Place' do
      it 'should have Place' do
        mock_graph :post, 'matake/feed', 'users/feed/post_with_valid_access_token', :access_token => 'access_token', :params => {
          :message => 'hello',
          :place => 'place_page_id'
        } do
          place = FbGraph::Place.new('place_page_id')
          post = FbGraph::User.new('matake', :access_token => 'access_token').feed!(:message => 'hello', :place => place)
          post.place.should == place
        end
      end
    end
  end
end