class Api::TweetsController < ApplicationController
  def index
    last_tweet = Episode.find(params[:episode_id]).tweets.last
    tweets = FetchTweetsService.call(params[:episode_id], params[:tweet_id], params[:progress_time_msec])
    render json: { tweets: tweets, fetch_last_tweet: tweets.include?(last_tweet) }
  end
end
