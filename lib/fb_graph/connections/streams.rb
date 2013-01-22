module FbGraph
  module Connections
    module Streams  # applies to Page, User, Application,and Group

      def streams(options = {})
        options[:access_token] ||= self.access_token
        options[:select] = Stream::ATTRS.join(",") if options[:select].nil?
        fql=%{ SELECT #{options[:select]}
            FROM stream
            WHERE source_id=#{self.identifier} AND is_hidden=0 }
        fql += " AND #{options[:where]}"      if options[:where].present?
        fql += " ORDER BY #{options[:order]}" if options[:order].present?
        fql += " LIMIT #{options[:limit]}"    if options[:limit].present?
        fql += " OFFSET #{options[:offset]}"  if options[:offset].present?
        response = http_client.get("#{FbGraph::ROOT_URL}/fql", {:q=>fql,:access_token=>options[:access_token]})
        Exception.handle_httpclient_error(response, response.headers) unless (200..300).include?(response.status)
        result = JSON.parse(response.body).with_indifferent_access
        result[:data].map! do |stream|
          Stream.new(stream[:post_id],stream.merge(:access_token => options[:access_token] || self.access_token))
        end
      end # def streams

    end
  end
end

