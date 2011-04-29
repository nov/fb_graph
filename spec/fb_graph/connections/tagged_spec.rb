# -*- coding: utf-8 -*-
require 'spec_helper'

describe FbGraph::Connections::Tagged, '#tagged' do
  context 'when included by FbGraph::User' do
    context 'when no access_token given' do
      it 'should return posts the user has been tagged as FbGraph::Post' do
        mock_graph :get, 'arjun/tagged', 'users/tagged/arjun_public' do
          posts = FbGraph::User.new('arjun').tagged
          posts.first.should == FbGraph::Post.new(
            '7901103_117809521578252',
            :from => {
              :id => '1404401889',
              :name => 'Elli Mooney'
            },
            :to => {
              :data => [{
                :id => '7901103',
                :name => 'Arjun Banker'
              }]
            },
            :message => '...uh oh, here comes a privacy issue....',
            :picture => 'http://external.ak.fbcdn.net/safe_image.php?d=c659c86d415c60c37b2871bfd67f2a97&w=130&h=130&url=http%3A%2F%2Fcdn.venturebeat.com%2Fwp-content%2Fuploads%2F2010%2F04%2Fusethisone.jpg',
            :link => 'http://venturebeat.com/2010/04/23/blippy-credit-card-citibank/',
            :name => 'Blippy users’ credit card numbers found on Google | VentureBeat',
            :caption => 'venturebeat.com',
            :description => '[Update: Blippy cofounder Philip Kaplan emailed a response. CNET News is reporting that the cards in question were issued by ...',
            :icon => 'http://static.ak.fbcdn.net/rsrc.php/zB010/hash/9yvl71tw.gif',
            :created_time => '2010-04-24T08:07:59+0000',
            :updated_time => '2010-04-24T08:07:59+0000',
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