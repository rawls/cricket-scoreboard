module Cricinfo
  # Manages fetching, parsing and caching cricket match data
  class Adapter
    DEFAULT_LIST_CACHE_EXPIRY  = 60 * 60 * 1 # 1 hour
    DEFAULT_MATCH_CACHE_EXPIRY =      60 * 2 # 2 minutes

    attr_reader :list_cached_at

    def initialize(config = {})
      Cricinfo.setup_log(config[:logger])
      @cache_expiry_list  = config[:cache_expiry_list]  || DEFAULT_LIST_CACHE_EXPIRY
      @cache_expiry_match = config[:cache_expiry_match] || DEFAULT_MATCH_CACHE_EXPIRY
      @connection         = Connection.new(config[:list_url], config[:match_url])
      @list_cached_at     = Time.parse('1970-01-01 00:00:00')
      @cached_matches     = {}
    end

    # Get an overview of the matches playing today
    def matches
      refresh_list_cache if list_cache_expired?
      @cached_matches.map { |key, val| [key, val[:match]] }.to_h
    end

    # Get the latest information about a particular match
    def match(match_id)
      @cached_matches[match_id] = refresh_match_cache(match_id) if match_cache_expired?(match_id)
      raise(NoSuchMatch, "Match ID:#{match_id}") unless @cached_matches[match_id]
      @cached_matches[match_id][:match]
    rescue StandardError => e
      Cricinfo.logger.error(e)
      nil
    end

    def match_cached_at(match_id)
      @cached_matches[match_id][:cached_at]
    rescue StandardError
      Time.parse('1970-01-01 00:00:00')
    end

    private

    # Update the list of matches
    def refresh_list_cache
      list = @connection.request_match_list
      # Add new matches
      (list.keys - @cached_matches.keys).each do |mid|
        data = refresh_match_cache(mid)
        @cached_matches[mid] = data if data
      end
      # Remove old matches
      (@cached_matches.keys - list.keys).each { |mid| @cached_matches.delete(mid) }
      # Update cache timestamp
      @list_cached_at = Time.now
      Cricinfo.logger.debug "Refreshed Matches: #{@cached_matches.keys.join(', ')}"
      true
    end

    # Update a particular match
    def refresh_match_cache(match_id)
      json = @connection.request_match_data(match_id)
      data = { match: Structs::Match.parse(json), cached_at: Time.now }
      Cricinfo.logger.debug "Refreshed Match ID:#{match_id} - #{data[:match].summary}"
      data
    rescue StandardError => e
      Cricinfo.logger.error "Match ID:#{match_id} Refresh Error: #{e.class} - #{e.message} (#{e.backtrace.first})"
      nil
    end

    # Check for match list cache staleness
    def list_cache_expired?
      @list_cached_at.nil? || (Time.now >= @list_cached_at + @cache_expiry_list)
    rescue StandardError
      true
    end

    # Check for match detail cache staleness
    def match_cache_expired?(match_id)
      (Time.now >= @cached_matches[match_id][:cached_at] + @cache_expiry_match)
    rescue StandardError
      true
    end

    class NoSuchMatch < StandardError; end
  end
end
