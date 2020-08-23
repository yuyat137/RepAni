class Api::TweetController < ApplicationController
  def index
    tweets = Tweets.all
    render json: tweets
  end
end
