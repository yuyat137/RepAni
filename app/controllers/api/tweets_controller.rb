class Api::TweetsController < ApplicationController
  def index
    last_tweet = Episode.find(params[:episode_id]).tweets.last
    tweets = FetchTweetsByProgressTimeService.call(params[:episode_id], params[:progress_time_msec])
    render json: {tweets: tweets, fetch_last_tweet: tweets.include?(last_tweet)}
  end
end
