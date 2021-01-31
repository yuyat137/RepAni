class Api::TweetsController < ApplicationController
  def index
    episode = Episode.find(params[:episode_id])
    max_tweet_id = episode.tweets.maximum(:tweet_id)
    last_tweet = episode.tweets.find_by(tweet_id: max_tweet_id)
    tweets = episode.return_tweets(params[:tweet_id], params[:progress_time_msec])
    render json: { tweets: tweets, last_tweet_exists: tweets.include?(last_tweet) }
  end
end
