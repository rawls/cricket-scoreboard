require 'date'

module Cricinfo
  module Structs
    # Represents detailed match information for a cricket match
    class Match < Base
      attr_reader   :start_date, :end_date, :series, :home_team, :away_team, :teams, :batsmen, :bowlers,
                    :innings, :wickets, :overs, :run_rate, :target, :break, :balls, :runs
      attr_accessor :ground

      NUM_PREVIOUS_BALLS = 6

      def initialize(start_date, end_date = nil, series = nil)
        @start_date = Date.parse(start_date)
        @end_date   = Date.parse(end_date || start_date)
        @series     = series
        @teams      = {}
        @innings    = []
        @balls      = []
        @batsmen    = []
        @bowlers    = []
      end

      def home_innings
        @innings.select { |inning| inning.batting_team == @home_team }
      end

      def away_innings
        @innings.select { |inning| inning.batting_team == @away_team }
      end

      # Construct a match object from a Cricinfo JSON hash
      def self.parse(json)
        matchj = json['match']
        livej  = json['live']
        match  = new(
          string(matchj, 'start_date_raw'),
          string(matchj, 'end_date_raw'),
          find_series(json['series'])
        )
        match.ground = Ground.parse(matchj)
        match.add_teams(matchj, json['team'])
        match.add_innings(json['innings'])
        match.add_score(livej)
        match.add_balls(json['comms'])
        match.add_batsmen(livej)
        match.add_bowlers(livej)
        match
      end

      # Gets the name of the series if one exists
      def self.find_series(seriesj)
        string(seriesj.first, 'series_short_name')
      rescue StandardError
        nil
      end

      # Parses team information from Cricinfo JSON hashes and adds it to the match
      def add_teams(matchj, teamsj)
        teamsj.each do |teamj|
          team = Team.parse(teamj)
          @teams[team.id] = team
        end
        @home_team = @teams[matchj['home_team_id'].to_s] || @teams.values.first
        @away_team = @teams[matchj['away_team_id'].to_s] || @teams.values.last
        @teams
      rescue StandardError => e
        Cricinfo.logger.warn(e)
        raise UnparseableMatch, 'Couldn\'t parse teams'
      end

      # Parses innings information from a Cricinfo JSON hash and adds it to the match
      def add_innings(inningsj)
        return unless inningsj

        @innings = inningsj.select { |inning| int(inning, 'innings_number').positive? }.map do |inningj|
          Innings.parse(@teams, inningj)
        end
      rescue StandardError => e
        Cricinfo.logger.warn(e)
        nil
      end

      # Parses current score info from a Cricinfo JSON hash and adds it to the match
      def add_score(livej)
        return unless livej && (inningsj = livej['innings'])

        @runs     = int(inningsj, 'runs')
        @wickets  = int(inningsj, 'wickets')
        @overs    = float(inningsj, 'overs')
        @run_rate = float(inningsj, 'run_rate')
        target    = int(inningsj, 'target')
        @target   = target.to_i.positive? ? target : nil
        @break    = string(livej, 'break')
      end

      # Parses information about the last n balls from a Cricinfo JSON hash and adds it to the match
      def add_balls(commsj)
        return unless commsj

        commsj.each do |commj|
          commj['ball'].each do |ballj|
            ball = Ball.parse(ballj)
            @balls << ball if ball
            break if @balls.size >= NUM_PREVIOUS_BALLS
          end
          break if @balls.size >= NUM_PREVIOUS_BALLS
        end
      rescue StandardError => e
        Cricinfo.logger.warn(e)
        nil
      end

      # Parses information about the current batsmen from a Cricinfo JSON hash and adds it to the match
      def add_batsmen(livej)
        return unless livej && livej['batting'] && !livej['batting'].empty?

        livej['batting'].each do |batsmanj|
          player = @teams&.fetch(batsmanj['team_id'])&.player(batsmanj['player_id']) rescue nil
          break unless player
          player.add_batting_info(batsmanj)
          @batsmen << player
        end
      end

      # Parses information about the current bowlers from a Cricinfo JSON hash and adds it to the match
      def add_bowlers(livej)
        return unless livej && livej['bowling'] && !livej['bowling'].empty?

        livej['bowling'].each do |bowlerj|
          player = @teams&.fetch(bowlerj['team_id'])&.player(bowlerj['player_id']) rescue nil
          break unless player

          player.add_bowling_info(bowlerj)
          @bowlers << player
        end
      end

      def runs_needed
        return nil unless @target

        @target - @runs
      end

      def day
        (Date.today - @start_date).to_i + 1
      end

      def multiday?
        @start_date < @end_date
      end

      # Pretty summary of the match
      def summary
        "#{@home_team.name} v #{@away_team.name}"
      rescue StandardError
        "Unknown match (ID:#{@id})"
      end

      class UnparseableMatch < StandardError; end
    end
  end
end
