class AnimeController < ApplicationController
  before_action :set_task, only: [:show, :update, :destroy]

  def index
    @animes = Anime.all
    render json: @animes
  end
end
