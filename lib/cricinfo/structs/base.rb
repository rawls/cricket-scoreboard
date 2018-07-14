module Cricinfo
  module Structs
    # Shared helper methods for the Cricinfo structs
    class Base
      def self.string(json, field_name)
        str = json&.fetch(field_name)
        str.empty? ? nil : str
      rescue StandardError
        nil
      end

      def string(json, field_name)
        self.class.string(json, field_name)
      end

      def self.int(json, field_name)
        json&.fetch(field_name)&.to_i
      rescue StandardError
        nil
      end

      def int(json, field_name)
        self.class.int(json, field_name)
      end

      def self.float(json, field_name)
        json&.fetch(field_name)&.to_f&.round(1)
      rescue StandardError
        nil
      end

      def float(json, field_name)
        self.class.float(json, field_name)
      end

      def self.date(json, field_name)
        Date.parse(json.fetch(field_name))
      rescue StandardError
        nil
      end

      def date(json, field_name)
        self.class.date(json, field_name)
      end

      def self.bool(json, field_name)
        json&.fetch(field_name)&.to_i&.positive?
      rescue StandardError
        false
      end

      def bool(json, field_name)
        self.class.bool(json, field_name)
      end
    end
  end
end
