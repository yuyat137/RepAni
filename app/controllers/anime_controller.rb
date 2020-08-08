class AnimeController < ApplicationController
  def index
    @animes = Anime.all
    render json: @animes
  end
end
