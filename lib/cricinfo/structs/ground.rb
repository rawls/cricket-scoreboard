module Cricinfo
  module Structs
    # Represents a cricket ground
    class Ground < Base
      attr_reader :name, :short_name, :latitude, :longitude

      def initialize(opts)
        @name       = opts[:name]
        @short_name = opts[:short_name]
        @latitude   = opts[:latitude]
        @longitude  = opts[:longitude]
      end

      # Construct a cricket ground object from a Cricinfo JSON hash
      def self.parse(matchj)
        new(
          name: string(matchj, 'ground_name', true),
          short_name: string(matchj, 'ground_small_name', true),
          latitude: float(matchj, 'ground_latitude'),
          longitude: float(matchj, 'ground_longitude')
        )
      rescue StandardError => e
        Cricinfo.logger.warn("Ball: #{e.message}")
        nil
      end
    end
  end
end
