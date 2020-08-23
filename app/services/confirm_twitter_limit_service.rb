class ConfirmTwitterLimitService
  private_class_method :new

  def self.confirm_limit
    new.confirm_limit
  end

  def confirm_limit
    twitter = Twitter::REST::Client.new do |config|
      config.consumer_key        = Settings.dig(:twitter, :consumer_key)
      config.consumer_secret     = Settings.dig(:twitter, :consumer_secret)
    end
    Twitter::REST::Request.new(twitter, :get, '/1.1/application/rate_limit_status.json').perform[:resources]
  end
end
