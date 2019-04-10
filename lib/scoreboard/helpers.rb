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

    def home_team_squad_url(match_id, match)
      "/squad/#{match_id}-#{match.summary.tr(' ', '-')}/#{match.home_team.id}-#{match.home_team.name.tr(' ', '-')}"
    end

    def away_team_squad_url(match_id, match)
      "/squad/#{match_id}-#{match.summary.tr(' ', '-')}/#{match.away_team.id}-#{match.away_team.name.tr(' ', '-')}"
    end

    # Describes a player's role in the team using a combination of role and bowling style (for bowlers)
    def role_description(player)
      case player.role
      when /bowler/i
        player.bowling_style ? [player.bowling_style, player.role].join(' ') : player.role
      else
        player.role
      end
    end

    def cached_at(match_id = nil)
      return settings.cricinfo.list_cached_at unless match_id

      settings.cricinfo.match_cached_at(match_id)
    rescue StandardError
      Time.parse('1970-01-01 00:00:00')
    end
  end
end
