require 'sinatra/base'

class CricinfoDummy < Sinatra::Base
  FIXTURE_FOLDER = File.dirname(__FILE__) + '/../fixtures/cricinfo/'

  get '/rss/livescores.xml' do
    content_type :xml
    status 200
    File.open(FIXTURE_FOLDER + 'livescores.xml', 'rb').read
  end

  get '/ci/engine/match/:match' do
    match_response 200, params['match']
  end

  private

  def match_response(response_code, file_name)
    content_type :json
    status response_code
    File.open(FIXTURE_FOLDER + 'matches/' + file_name, 'rb').read
  rescue StandardError
    status 404
    'Not found'
  end
end
