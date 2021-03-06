# config valid for current version and patch releases of Capistrano
lock '~> 3.14.1'

set :application,   'cricket-scoreboard'
set :repo_url,      "git@github.com:rawls/#{fetch(:application)}.git"
set :deploy_to,     "/var/www/#{fetch(:application)}"
set :keep_releases, 2

append :linked_dirs,  'log', 'tmp'
append :linked_files, 'RACK_ENV', 'config/scoreboard.yml'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure
