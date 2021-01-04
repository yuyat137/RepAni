class ConfirmTwitterLimitService
  private_class_method :new

  def self.call(args = nil)
    new.call(args)
  end

  def call(args)
    twitter = Twitter::REST::Client.new do |config|
      config.consumer_key        = Settings.dig(:twitter, :consumer_key)
      config.consumer_secret     = Settings.dig(:twitter, :consumer_secret)
    end
    twitter_limit_list = Twitter::REST::Request.new(twitter, :get, '/1.1/application/rate_limit_status.json').perform[:resources]

    case args
    when :search
      twitter_limit_list[:search][:"/search/tweets"][:remaining]
    else
      twitter_limit_list
    end
  end
end
