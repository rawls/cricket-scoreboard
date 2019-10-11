source 'https://rubygems.org'

# Web server
gem 'thin'

# Web application
gem 'i18n'
gem 'sinatra'

# Asset management
gem 'sass'
gem 'sprockets', '~> 3'
gem 'sprockets-helpers'
gem 'uglifier'

# Cricinfo response parsing
gem 'nokogiri'

# Testing resources
group :development, :test do
  gem 'byebug', require: false
  gem 'erb_lint', require: false
  gem 'factory_bot'
  gem 'rack-test'
  gem 'rspec'
  gem 'rspec-html-matchers'
  gem 'rubocop', require: false
  gem 'rubocop-rspec', require: false
  gem 'simplecov', require: false
  gem 'timecop', require: false
  gem 'webmock'
end

group :development do
  gem 'capistrano'
  gem 'capistrano-bundler'
  gem 'capistrano-rvm'
end
