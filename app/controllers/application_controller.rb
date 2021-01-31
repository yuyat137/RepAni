class ApplicationController < ActionController::Base
  protect_from_forgery unless: -> { request.format.json? }
  add_flash_types :success, :info, :warning, :danger
end
