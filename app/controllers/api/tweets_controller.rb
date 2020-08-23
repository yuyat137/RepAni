class Api::TweetsController < ApplicationController
  def index
    # first(5)は一時的な対処
    tweets = Tweet.first(5)
    render json: tweets
  end
end
