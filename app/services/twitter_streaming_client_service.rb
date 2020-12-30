class TwitterStreamingClientService
  private_class_method :new

  def self.call(hashtag)
    new.call(hashtag)
  end

  def call(hashtag)
    hashtag = "##{hashtag unless hashtag.include?('#')}"

    twitter = Twitter::Streaming::Client.new do |config|
      config.consumer_key        = Settings.dig(:twitter, :consumer_key)
      config.consumer_secret     = Settings.dig(:twitter, :consumer_secret)
      config.access_token        = Settings.dig(:twitter, :access_token)
      config.access_token_secret = Settings.dig(:twitter, :access_token_secret)
    end

    twitter.filter(track: hashtag) do |object|
      puts object.id if object.is_a?(Twitter::Tweet)
      puts object.user.screen_name if object.is_a?(Twitter::Tweet)
      puts object.text if object.is_a?(Twitter::Tweet)
    end
  end
end
