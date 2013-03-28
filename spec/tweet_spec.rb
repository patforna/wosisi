require 'spec_helper'

describe Tweet do
  
  describe "load" do
    it "load tweets from pat's public timeline" do
      tweets = [Twitter::Tweet.new(:id => 0, :created_at => Time.now.to_s)]
      Twitter.should_receive(:user_timeline).with('patforna', anything()).and_return(tweets)
      Tweet.load().should == tweets
    end
    
    it "should serve old tweets if something goes haywire" do
      tweets = [Twitter::Tweet.new(:id => 0, :created_at => Time.now.to_s)]
      Twitter.should_receive(:user_timeline).and_return(tweets)
      Twitter.should_receive(:user_timeline).and_raise(:boom)
      Tweet.load().should == tweets
      Tweet.load().should == tweets      
    end    
    
  end

end