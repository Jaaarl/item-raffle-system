class Client::ShareController < ApplicationController
  def index
    @feedbacks = Winner.published.page(params[:page]).per(5).order(created_at: :desc)
    @banners = Banner.active.where('online_at <= ? AND offline_at > ?', Date.current, Date.current).order(:sort)
    @news_tickers = NewsTicker.active.order(:sort)
  end
end