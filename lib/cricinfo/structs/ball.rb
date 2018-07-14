module Cricinfo
  module Structs
    # Represents a ball from an over
    class Ball < Base
      attr_reader :over, :players, :event

      def initialize(opts)
        @over       = opts[:over]
        @players    = opts[:players]
        @event      = opts[:event]
      end

      def boundary?
        %w[FOUR SIX].include? @event
      end

      def wicket?
        @event == 'OUT'
      end

      def summary
        "#{@over}: #{@players}, #{@event}"
      end

      # Construct a ball object from a Cricinfo JSON hash
      def self.parse(ballj)
        new(
          over:    float(ballj, 'overs_actual'),
          players: string(ballj, 'players'),
          event:   string(ballj, 'event')
        )
      end
    end
  end
end
