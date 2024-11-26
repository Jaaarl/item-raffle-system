class Client::ShareController < ApplicationController
  def index
    @feedbacks = Winner.published.page(params[:page]).per(3)
  end
end