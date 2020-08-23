class Api::EpisodesController < ApplicationController
  def index
    episodes = Anime.find(params[:id]).episodes
    render json: episodes
  end
end
