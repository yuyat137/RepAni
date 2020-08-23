class Api::TweetsController < ApplicationController
  def index
    tweets = Tweet.all
    render json: tweets
  end
end
