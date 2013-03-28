# unit tests
require 'place'
require 'route'
require 'helpers'
require 'json_spec'

# functional tests
ENV['RACK_ENV'] = 'test'
require File.join(File.dirname(__FILE__), '..', 'web.rb')
require 'rack/test'
require 'webmock/rspec'

RSpec.configure do |conf|
  conf.include Helpers
  conf.include Rack::Test::Methods
  conf.include WebMock::API
end

# helper methods
require 'twitter'
def tweet(message) 
  Twitter::Tweet.new(:id => 0, :text => message)
end