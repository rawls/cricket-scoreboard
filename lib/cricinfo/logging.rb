require 'logger'
# Log utilities
module Cricinfo
  # Return the logger object
  def self.logger
    $logger ||= setup_log
    $logger
  end

  # Create and configure a new logger object
  def self.setup_log(logger = Logger.new(ENV['LOG'].nil? ? nil : STDOUT))
    $logger = logger
  end
end
