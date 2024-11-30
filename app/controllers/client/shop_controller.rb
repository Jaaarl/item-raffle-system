class Client::ShopController < ApplicationController
  before_action :set_offer, only: [:show, :buy]

  def index
    @offers = Offer.active
    @banners = Banner.active.where('online_at <= ? AND offline_at > ?', Date.current, Date.current)
    @news_tickers = NewsTicker.active
  end

  def show; end

  def buy
    if current_client_user
        @order = Order.create(user: current_client_user, offer: @offer, amount: @offer.amount, coin: @offer.coin, genre: "deposit")
        @order.save
        flash[:notice] = "Offer purchased successfully!"
      redirect_to client_shop_index_path
    else
      flash[:alert] = "You must be signed in to purchase a Offer. Please sign in first."
      redirect_to new_client_user_session_path
    end
  end

  private

  def set_offer
    @offer = Offer.find(params[:id])
  end
end