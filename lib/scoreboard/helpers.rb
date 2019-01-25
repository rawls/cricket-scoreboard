module Scoreboard
  # Sinatra helpers
  module Helpers
    def list
      settings.cricinfo.matches
    end

    def match_data(match_id)
      settings.cricinfo.match(match_id)
    end

    def tracking_id
      settings.tracking_id
    rescue StandardError
      nil
    end

    def match_status(match)
      day = match.multiday? ? "#{I18n.t(:'index.day')} #{match.day} " : ''
      match.break.nil? || match.break.empty? ? day : match.break
    rescue StandardError
      nil
    end

    def cached_at(match_id = nil)
      return settings.cricinfo.list_cached_at unless match_id

      settings.cricinfo.match_cached_at(match_id)
    rescue StandardError
      Time.parse('1970-01-01 00:00:00')
    end
  end
end
