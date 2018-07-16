module Cricinfo
  module Structs
    # Represents a single innnings in a cricket match
    class Innings < Base
      attr_reader :batting_team, :fielding_team, :balls, :runs, :wickets

      def initialize(opts = {})
        @batting_team   = opts[:batting_team]
        @fielding_team  = opts[:fielding_team]
        @balls          = opts[:balls]
        @runs           = opts[:runs]
        @wickets        = opts[:wickets]
      end

      def summary
        "#{@runs} / #{@wickets}"
      end

      # Construct an innings object from a Cricinfo JSON hash
      def self.parse(teams, inningsj)
        batting_team_id  = string(inningsj, 'batting_team_id')
        fielding_team_id = string(inningsj, 'bowling_team_id')
        unless batting_team_id && fielding_team_id
          Cricinfo.logger.warn('Innings: missing team id')
          return nil
        end
        new(
          batting_team:  teams[batting_team_id],
          fielding_team: teams[fielding_team_id],
          balls:         int(inningsj, 'balls'),
          runs:          int(inningsj, 'runs'),
          wickets:       int(inningsj, 'wickets')
        )
      rescue StandardError => e
        Cricinfo.logger.warn("Innings: #{e.message}")
        nil
      end
    end
  end
end
