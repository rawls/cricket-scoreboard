module Cricinfo
  module Structs
    # Shared helper methods for the Cricinfo structs
    class Base
      def self.string(json, field_name, required = false)
        enforce_required(required, field_name) do
          str = json&.fetch(field_name)
          str.empty? ? nil : str
        end
      end

      def string(json, field_name, required = false)
        self.class.string(json, field_name, required)
      end

      def self.int(json, field_name, required = false)
        enforce_required(required, field_name) do
          json&.fetch(field_name)&.to_i
        end
      end

      def int(json, field_name, required = false)
        self.class.int(json, field_name, required)
      end

      def self.float(json, field_name, required = false)
        enforce_required(required, field_name) do
          json&.fetch(field_name)&.to_f&.round(1)
        end
      end

      def float(json, field_name, required = false)
        self.class.float(json, field_name, required)
      end

      def self.date(json, field_name, required = false)
        enforce_required(required, field_name) do
          Date.parse(json.fetch(field_name))
        end
      end

      def date(json, field_name, required = false)
        self.class.date(json, field_name, required)
      end

      def self.bool(json, field_name)
        json&.fetch(field_name)&.to_i&.positive?
      rescue StandardError
        false
      end

      def bool(json, field_name)
        self.class.bool(json, field_name)
      end

      def self.enforce_required(required, field_name, &block)
        value = block.call
        raise "Missing required field #{field_name}" if required && value.nil?
        value
      rescue StandardError
        raise "Missing required field #{field_name}" if required
        nil
      end
    end
  end
end
