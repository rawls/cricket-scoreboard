require 'pathname'
require 'fileutils'
BASE = Pathname.new(__FILE__).realpath.parent.parent unless defined? BASE

# TODO: If converted to a gem need to get/set 'BASE'
# Utility methods for managing Ruby processes
module ProgramTools
  LOG_DIRECTORY = BASE + 'log'
  PID_DIRECTORY = BASE + 'tmp' + 'pids'

  def self.daemonise(process_name = 'app')
    background  process_name
    store_pid   process_name
    redirect_io process_name
  end

  # https://gist.github.com/mvidner/bf12a0b3c662ca6a5784
  # Signal handlers with support for logging
  def self.handle_signal(*signals, &block)
    if defined?(EM)
      evented_signal_handler(signals, block)
    else
      threaded_signal_handler(signals, block)
    end
  end

  def self.connect_to_database(yaml, environment)
    # TODO: Manage EM threadpool
  end

  # Log file to a file and ignore terminal input
  def self.redirect_io(process_name)
    STDIN.reopen('/dev/null') # Ignore terminal input
    # Find a spot for the log
    FileUtils.mkdir(LOG_DIRECTORY) unless File.exist?(LOG_DIRECTORY)
    log_file = LOG_DIRECTORY + "#{process_name}.log"
    # Redirect output to the logfile
    $stdout.reopen(log_file, 'a')
    $stderr.reopen(log_file, 'a')
    # Enable sync so that log lines arrive in a timely fashion
    $stdout.sync = true
    $stderr.sync = true
  end

  # Runs the process in the background and disdowns its parent
  private_class_method def self.background(process_name)
    exit!(0) if fork # Fork and exit the grandparent to ensure that the process isn't a group leader
    Process.setsid # Create a new session so this process doesn't have a controlling terminal
    exit!(0) if fork # Fork and exit the parent to ensure that the process isn't a session leader
    Dir.chdir(BASE) # Set the working directory to the project folder to protect against mount issues
    puts "Started #{process_name} in the background with pid #{Process.pid}"
  end

  # Stores the process ID until the process exits
  private_class_method def self.store_pid(process_name)
    # Find a spot for the pid
    FileUtils.mkdir_p(PID_DIRECTORY) unless File.exist?(PID_DIRECTORY)
    pidfile = PID_DIRECTORY + "#{process_name}.pid"
    File.write(pidfile, Process.pid.to_s) # Store the pid
    at_exit { File.delete(pidfile) if File.exist?(pidfile) } # Delete it on shutdown
  end

  # Evented signal traps with support for logging
  private_class_method def self.evented_signal_handler(signals, block)
    signals.each do |signal|
      Signal.trap(signal) do
        # The traps add a job for EM to do in zero seconds
        # This gets us out of the trap context and re-enables log writing
        EM.add_timer(0) do
          puts "Received SIG#{signal}"
          EM.stop if block.nil?
          block.call
        end
      end
    end
  end

  # Threaded signal traps with support for logging
  private_class_method def self.threaded_signal_handler(signals, block)
    # The traps put the name of the signal onto an array for the signal thread to read
    Thread.main[:pending_signals] ||= []
    signals.each do |signal|
      Signal.trap(signal) { Thread[:pending_signals] << signal }
    end
    # This thread loops every second and runs the signal handler block if it has received a signal
    Thread.main[:signal_handler_thread] ||= Thread.new do
      loop do
        sleep 1
        while (signal = Thread.main[:pending_signals].shift)
          # TODO: Support for different blocks for each signal
          puts "Received SIG#{signal}"
          exit if block.nil?
          block.call
        end
      end
    end
  end
end
