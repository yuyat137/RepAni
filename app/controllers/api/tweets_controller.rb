class Api::TweetsController < ApplicationController
  def index
    episode = Episode.find(params[:episode_id])
    last_tweet = episode.tweets.last
    tweets = episode.return_tweets(params[:tweet_id], params[:progress_time_msec])
    render json: { tweets: tweets, fetch_last_tweet: tweets.include?(last_tweet) }
  end
end
