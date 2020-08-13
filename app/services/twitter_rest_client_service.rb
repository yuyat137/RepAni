class TwitterRestClientService
  private_class_method :new

  def self.twitter_client
    new.twitter_client
  end

  def twitter_client
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = Settings.dig(:twitter, :consumer_key)
      config.consumer_secret     = Settings.dig(:twitter, :consumer_secret)
      config.access_token        = Settings.dig(:twitter, :access_token)
      config.access_token_secret = Settings.dig(:twitter, :access_token_secret)
    end
  end
end
