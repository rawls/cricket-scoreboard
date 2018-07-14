module Cricinfo
  module Structs
    # Represents a cricket team
    class Team < Base
      attr_reader :id, :name, :short_name, :players

      def initialize(opts)
        @id         = opts[:id]
        @name       = opts[:name]
        @short_name = opts[:short_name]
        @players    = {}
      end

      # Construct a team object from a Cricinfo JSON hash
      def self.parse(teamj)
        team = new(
          id:         string(teamj, 'team_id'),
          name:       string(teamj, 'team_name'),
          short_name: string(teamj, 'team_abbreviation')
        )
        team.add_players(teamj)
        team
      end

      # Fetch a specific player from this team
      def player(player_id)
        @players[player_id]
      end

      # Add players to the team from a Cricinfo JSON hash
      def add_players(teamj)
        type = %w[player squad].detect { |t| !teamj[t].nil? }
        return unless type
        teamj[type].each do |playerj|
          player = Player.parse(playerj)
          @players[player.id] = player
        end
        @players
      rescue StandardError => e
        Cricinfo.logger.error(e)
      end
    end
  end
end
