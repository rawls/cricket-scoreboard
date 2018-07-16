module Cricinfo
  module Structs
    # Represents a cricket player
    class Player < Base
      attr_reader :id, :name, :dob, :role, :batting_style, :bowling_style, :captain
      attr_reader :wickets, :conceded, :overs, :economy
      attr_reader :runs, :balls_faced, :strike_rate

      def initialize(opts = {})
        @id             = opts[:id]
        @name           = opts[:name]
        @dob            = opts[:dob]
        @role           = opts[:role]
        @batting_style  = opts[:battling_style]
        @bowling_style  = opts[:bowling_style]
        @captain        = opts[:captain]
      end

      # Construct a player object from a Cricinfo JSON hash
      def self.parse(playerj)
        new(
          id:             string(playerj, 'player_id', true),
          name:           string(playerj, 'known_as', true),
          dob:            date(playerj, 'dob'),
          role:           string(playerj, 'player_primary_role'),
          battling_style: string(playerj, 'batting_style_long'),
          bowling_style:  string(playerj, 'bowling_style_long'),
          captain:        bool(playerj, 'captain')
        )
      end

      # Add batting stats to this player from a Cricinfo JSON hash
      def add_batting_info(batsmanj)
        @runs        = int(batsmanj, 'runs')
        @balls_faced = int(batsmanj, 'balls_faced')
        @strike_rate = float(batsmanj, 'strike_rate')
      end

      # Add bowling status to this player from a Cricinfo JSON hash
      def add_bowling_info(bowlerj)
        @wickets  = int(bowlerj, 'wickets')
        @conceded = int(bowlerj, 'conceded')
        @overs    = float(bowlerj, 'overs')
        @economy  = float(bowlerj, 'economy_rate')
      end

      def surname
        @name.split(' ').last
      end
    end
  end
end
