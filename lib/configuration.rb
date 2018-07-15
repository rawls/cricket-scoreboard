# Application config builder
class Configuration
  def self.parse(yaml)
    config = ENV['CONTAINER'].nil? ? YAML.load_file(yaml) : from_environment
    apply_defaults(config)
  end

  def self.from_environment
    {
      log_level: ENV['LOG_LEVEL'],
      webserver: {
        server: ENV['WEBSERVER'],
        host:   ENV['HOST'],
        port:   ENV['PORT']
      },
      cricinfo: {
        list_url:           ENV['LIST_URL'],
        match_url:          ENV['MATCH_URL'],
        list_cache_expiry:  ENV['LIST_CACHE_EXPIRY'].to_i,
        match_cache_expiry: ENV['MATCH_CACHE_EXPIRY'].to_i
      }
    }
  end

  def self.apply_defaults(config) # rubocop:disable Metrics/AbcSize
    config[:log_level]                     ||= 'INFO'
    config[:webserver]                     ||= {}
    config[:webserver][:server]            ||= 'thin'
    config[:webserver][:host]              ||= '0.0.0.0'
    config[:webserver][:port]              ||= 4567
    config[:cricinfo]                      ||= {}
    config[:cricinfo][:list_url]           ||= 'http://static.cricinfo.com/rss/livescores.xml'
    config[:cricinfo][:match_url]          ||= 'http://www.espncricinfo.com/ci/engine/match/'
    config[:cricinfo][:list_cache_expiry]    = 3600 if config[:cricinfo][:list_cache_expiry].to_i.zero?
    config[:cricinfo][:match_cache_expiry]   = 120  if config[:cricinfo][:list_cache_expiry].to_i.zero?
    config
  end
end
