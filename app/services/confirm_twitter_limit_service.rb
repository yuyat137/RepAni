class ConfirmTwitterLimitService
  private_class_method :new

  def self.call
    new.call
  end

  def call
    twitter = Twitter::REST::Client.new do |config|
      config.consumer_key        = Settings.dig(:twitter, :consumer_key)
      config.consumer_secret     = Settings.dig(:twitter, :consumer_secret)
    end
    Twitter::REST::Request.new(twitter, :get, '/1.1/application/rate_limit_status.json').perform[:resources]
  end
end
