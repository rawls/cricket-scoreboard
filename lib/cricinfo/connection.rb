require 'nokogiri'
require 'json'
require 'net/http'
require 'uri'

module Cricinfo
  # Handles HTTP communication with Cricinfo
  class Connection
    DEFAULT_LIST_URL = 'http://static.cricinfo.com/rss/livescores.xml'.freeze
    DEFAULT_DATA_URL = 'http://www.espncricinfo.com/ci/engine/match/'.freeze

    def initialize(list_url = DEFAULT_LIST_URL, data_url = DEFAULT_DATA_URL)
      @list_url = list_url || DEFAULT_LIST_URL
      @data_url = data_url || DEFAULT_DATA_URL
    end

    # Get a list of active cricket matches from an RSS feed
    def request_match_list
      matches  = {}
      response = Net::HTTP.get_response(URI(@list_url))
      Cricinfo.logger.info "Match List Response: #{response.code}"
      xml_matches(response.body).each do |match|
        matches[match_id(match)] = match_description(match)
      rescue StandardError
        nil
      end
      matches
    rescue StandardError
      matches
    end

    # Get detailed information about a specific cricket match from the JSON API
    def request_match_data(match_id)
      uri      = URI(@data_url + match_id.to_s + '.json')
      response = Net::HTTP.get_response(uri)
      Cricinfo.logger.info "Match ID:#{match_id} Response: #{response.code}"
      JSON.parse(response.body)
    end

    private

    def xml_matches(xml)
      Nokogiri::XML(xml).xpath('/rss/channel/item')
    end

    def match_id(match_xml)
      match_xml.xpath('./guid')[0].content.split('/').last.split('.')[0]
    end

    def match_description(match_xml)
      match_xml.xpath('./description')[0].content
    end
  end
end
