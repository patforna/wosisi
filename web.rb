require 'sinatra'
require 'twitter'
require './lib/tweet'
require './lib/place'
require './lib/route'
require './lib/helpers'

configure :production do
  require 'newrelic_rpm'  
  require 'dalli'
  require 'rack-cache'  
  $cache = Dalli::Client.new
  use Rack::Cache, :verbose => true, :metastore => $cache, :entitystore => $cache, :allow_reload => false  
  set :static_cache_control, [:public, :max_age => 60]  
end

before do
  cache_control :public, :max_age => 60
end

get '/' do
  tweets = Tweet.load
  @last_tweet = tweets.first
  @route = Route.from(tweets)
  @last_place = @route.last_place

  erb :index
end

helpers do 
  include Helpers
end