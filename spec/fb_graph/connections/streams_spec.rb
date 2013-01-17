require 'spec_helper'

describe FbGraph::Connections::Streams, '#streams' do
  context 'when included by FbGraph::Page' do
    context 'when access_token is given' do
      it 'should return streams on the page\'s wall as FbGraph::Stream' do
        fql = "%20SELECT%20post_id,likes,share_count,comments,viewer_id,app_id,updated_time,created_time,filter_key,attribution,actor_id,target_id,message,app_data,action_links,attachment,impressions,place,description,type%0A%20%20%20%20%20%20%20%20%20%20%20%20FROM%20stream%0A%20%20%20%20%20%20%20%20%20%20%20%20WHERE%20source_id=229631577118807%20AND%20is_hidden=0%20"
        mock_graph :get, 'fql?q='+fql, File.join(MOCK_JSON_DIR, 'streams/page_streams_with_access_token.json'), :access_token => 'access_token' do
          streams = FbGraph::Page.new(229631577118807).streams(:access_token => 'access_token')
          streams.each do |stream|
            stream.should be_instance_of(FbGraph::Stream)
          end
        end
      end
    end
  end
end
