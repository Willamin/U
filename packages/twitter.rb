require 'tweetstream'

class TwitterUtils < U::Package
  VERSION = '0.0.1'

  script 'listen to twitter' do
    uprint "Configuring the Twitter COM Link..."

    TweetStream.configure do |config|
      config.consumer_key     = ENV['TW_CONSUMER_KEY']
      config.consumer_secret  = ENV['TW_CONSUMER_SECRET']

      config.oauth_token        = ENV['TW_OAUTH_TOKEN']
      config.oauth_token_secret = ENV['TW_OAUTH_TOKEN_SECRET']

      config.auth_method = :oauth
    end

    terms = [] # what you want to watch twitter for
    tweets = [] # should actually push these into redis

    begin
      TweetStream::Client.new.track terms do |status|
        if status.lang == 'en'
          tweets << status
          uprint status.text
        end
      end
    rescue SystemExit, Interrupt => e

      uprint "Saving tweets", :warn

      File.open(File.join(Dir.pwd, 'tweets.txt'), 'a') do |file|
        tweets.each do |tweet|
          file.puts("Tweet: #{tweet.text} | URL: #{tweet.url}")
        end
      end

      abort
    end
  end
end
