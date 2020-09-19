class TwitterRestClientService
  private_class_method :new

  def self.call
    new.call
  end

  def call
    Twitter::REST::Client.new do |config|
      config.consumer_key        = Settings.dig(:twitter, :consumer_key)
      config.consumer_secret     = Settings.dig(:twitter, :consumer_secret)
    end
  end
end
