class Client::ShareController < ApplicationController
  def index
    @feedbacks = Winner.published.page(params[:page]).per(3).order(created_at: :desc)
    @banners = Banner.active.where('online_at <= ? AND offline_at > ?', Date.current, Date.current).order(created_at: :desc)
    @news_tickers = NewsTicker.active.order(created_at: :desc)
  end
end