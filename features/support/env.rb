# Require simple coverage.
require 'simplecov'
# Require all the parts needed for capybara testing.
require 'capybara'
require 'rspec'
require 'capybara/cucumber'

# Run a simple coverage using the features directory.
SimpleCov.start do
  add_filter 'features/'
end

# Rack environment variable.
ENV['RACK_ENV'] = 'test'

# Points to the app controller.
require_relative '../../bookmark-site'

# Set the capybara to use sinatra.
Capybara.app = Sinatra::Application

# Class for the application.
class Sinatra::ApplicationWorld
  include RSpec::Expectations
  include RSpec::Matchers
  include Capybara::DSL
end

# Instantiate the application within the testing env.
World do
	Sinatra::ApplicationWorld.new  
end
