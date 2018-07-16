require 'rack'
require 'thin'

module Scoreboard
  # Scoreboard rack webserver
  class Server
    def initialize(cricinfo, opts = {})
      @cricinfo = cricinfo
      @server   = opts[:server]   || 'thin'
      @host     = opts[:host]     || '0.0.0.0'
      @port     = opts[:port]     || 4567
      @interval = opts[:interval] || 150
      @logger   = opts[:logger]   || Logger.new(STDOUT)
      @dispatch = setup_rack
      Thin::Logging.logger = @logger if @server == 'thin'
    end

    def setup_rack
      App.set :logger, @logger
      App.set :cricinfo, @cricinfo
      App.set :refresh_interval, @interval
      Rack::Builder.app do
        map('/') { run App.new }
      end
    end

    def start
      @logger.info "Starting #{@server} webserver on #{@host}:#{@port}"
      Rack::Server.start(
        app:       @dispatch,
        server:    @server,
        Host:      @host,
        Port:      @port,
        AccessLog: @logger
      )
      self
    end
  end
end
