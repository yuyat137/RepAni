class Api::AnimesController < ApplicationController
  def index
    @animes = Anime.all
    render json: @animes
  end
end
