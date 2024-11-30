class Client::ShareController < ApplicationController
  def index
    @feedbacks = Winner.published.page(params[:page]).per(3)
    @banners = Banner.active.where('online_at <= ? AND offline_at > ?', Date.current, Date.current)
  end
end