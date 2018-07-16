require 'sinatra/base'
require 'sprockets'
require 'sprockets-helpers'
require 'json'
require 'pathname'
require 'uglifier'
require 'sass'
require 'i18n'
require 'i18n/backend/fallbacks'

module Scoreboard
  # Scoreboard sinatra web application
  class App < Sinatra::Base
    configure do
      set :root,              Pathname.new(File.dirname(__FILE__)).parent.parent
      set :public_folder,     (proc { File.join(root, 'public') })
      set :views,             (proc { File.join(root, 'views') })
      set :logger,            Logger.new(STDOUT)
      set :environment,       ENV['RACK_ENV'] || 'development'
      set :refresh_interval,  150
      # Translations
      I18n::Backend::Simple.send(:include, I18n::Backend::Fallbacks)
      I18n.load_path = Dir[File.join(root, 'locales', '*.yml')]
      I18n.backend.load_translations
      # Management of assets
      set :sprockets,     Sprockets::Environment.new(root)
      set :assets_prefix, '/assets'
      set :digest_assets, true
      sprockets.append_path 'assets/stylesheets'
      sprockets.append_path 'assets/javascripts'
      sprockets.append_path 'assets/fonts'
      sprockets.js_compressor  = Uglifier.new(mangle: true)
      sprockets.css_compressor = :scss
      Sprockets::Helpers.configure do |config|
        config.environment = sprockets
        config.prefix      = assets_prefix
        config.digest      = digest_assets
        config.public_path = public_folder
        config.debug       = environment == 'development'
      end
    end

    helpers Sprockets::Helpers
    helpers Scoreboard::Helpers

    before do
      # TODO: Default cache lifetimes based on cricinfo cache times per request and looong cache times for assets
      cache_control :public, :must_revalidate, max_age: 60
    end

    # Display a list of available matches
    get '/' do
      last_modified(cached_at)
      erb(:'index.html', locals: { matches: list })
    end

    # Render a scoreboard for a single match
    get '/scoreboard/:match_id' do
      match_id = params[:match_id].split('-').first # SEO-friendly paths
      last_modified(cached_at(match_id))
      erb(:'match.html', locals: {
            match_id: match_id,
            match:    match_data(match_id),
            interval: settings.refresh_interval
          })
    end

    # Render the scoreboard partial on its own
    post '/scoreboard' do
      match_id = params[:match_id]
      last_modified(cached_at(match_id))
      erb(:'_scoreboard.html', layout: false, locals: {
            match_id: match_id,
            match:    match_data(match_id)
          })
    end

    # Serve assets using sprockets
    get '/assets/*' do
      env['PATH_INFO'].sub!('/assets', '')
      settings.sprockets.call(env)
    end

    # Health check
    get '/status' do
      content_type :json
      { cached_at: cached_at.strftime('%F %T') }.to_json
    end
  end
end
