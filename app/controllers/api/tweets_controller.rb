class Api::TweetsController < ApplicationController
  before_action :set_tweets

  def index
    render json: @tweets
  end

  private

  def set_tweets
    @tweets = Episode.find(params[:episode_id]).tweets.first(300)
  end
end
