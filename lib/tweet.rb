require 'twitter'

class Tweet
  START_DATE = Time.new(2013,3,1)
  
  def self.load() 
    @@tweets ||= []
    begin
      @@tweets = Twitter.user_timeline("wosisi", :count => 200, :exclude_replies => true, :include_rts => false, :trim_user => true, :include_entities => false).select { |t| t.created_at > START_DATE }
    rescue => e
      puts 'Failed to get tweets from Twitter. Falling back to last known tweets. ' + e.message
      @@tweets
    end
  end  
end
