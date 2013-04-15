require 'json'
require 'twitter'
require 'geocoder'

class Place
  LAT_LONG_PATTERN = / ?(-?\d+\.\d+), ?(-?\d+\.\d+)/
  TWEET_WITH_LAT_LONG_PATTERN = /(^|(.* ))#{LAT_LONG_PATTERN}( .*|$)/  
  UNKNOWN = "Not sure the name of the place"
  
  attr_reader :latitude, :longitude, :visited_at, :tweet
  
  def self.parse(tweet)
    if tweet.geo
      Place.new(tweet.geo.latitude, tweet.geo.longitude, tweet.created_at, tweet)
    else
      tweet.text =~ TWEET_WITH_LAT_LONG_PATTERN
      Place.new($3, $4, tweet.created_at, tweet)
    end    
  end    
  
  def initialize(latitude=nil, longitude=nil, visited_at=nil, tweet=nil)
    @latitude = latitude.to_f if latitude
    @longitude = longitude.to_f if longitude
    @visited_at = visited_at
    @tweet = tweet
  end
  
  def unknown?
    @latitude.nil? || @longitude.nil?
  end
    
  def name
    @name = compute_name if @name.nil?
  end
  
  def to_json(*a)
    {:latitude => @latitude, :longitude => @longitude, :visited_at => @visited_at, :tweet => Rack::Utils.escape_html(@tweet.text)}.to_json(*a)
  end
  
  def ==(other)
    @latitude == other.latitude && @longitude == other.longitude
  end
  
  private
  def compute_name
    begin
      address = Geocoder.search("#{latitude},#{longitude}").first.formatted_address
      parts = address.split(', ')
      parts = parts.drop parts.length - 2 if parts.length > 2
      parts = parts.map {|p| p.gsub(/\s?\d+\s?/, '') }
      parts.join(', ')

      #result = Twitter.reverse_geocode(:lat => latitude, :long => longitude, :granularity => "city", :max_results => 1).first
      #parts = [result.full_name]
      #parts << result.country if result.country?
      #parts.join(', ')
    rescue
      UNKNOWN
    end
  end
  
end
