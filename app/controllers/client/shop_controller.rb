class Client::ShopController < ApplicationController
  before_action :set_offer, only: [:show, :buy]

  def index
    @offers = Offer.active.order(created_at: :desc).page(params[:page]).per(12)
    @banners = Banner.active.where('online_at <= ? AND offline_at > ?', Date.current, Date.current).order(:sort)
    @news_tickers = NewsTicker.active.order(:sort)
  end

  def show; end

  def buy
    if current_client_user
      if @offer.one_time?
        if Order.exists?(user: current_client_user, offer: @offer, state: [:pending, :submitted, :paid])
          flash[:alert] = "You have already purchased this one-time offer."
          redirect_to client_shop_index_path and return
        end
      elsif @offer.monthly?
        if Order.exists?(user: current_client_user, offer: @offer, state: [:pending, :submitted, :paid]) ||
          Order.where(user: current_client_user, offer: @offer).where('created_at >= ?', Time.current.beginning_of_month).exists?
          flash[:alert] = "You can only purchase this monthly offer once per month."
          redirect_to client_shop_index_path and return
        end
      elsif @offer.weekly?
        if Order.exists?(user: current_client_user, offer: @offer, state: [:pending, :submitted, :paid]) ||
          Order.where(user: current_client_user, offer: @offer).where('created_at >= ?', Time.current.beginning_of_week).exists?
          flash[:alert] = "You can only purchase this weekly offer once per week."
          redirect_to client_shop_index_path and return
        end
      elsif @offer.daily?
        if Order.exists?(user: current_client_user, offer: @offer, state: [:pending, :submitted, :paid]) ||
          Order.where(user: current_client_user, offer: @offer).where('created_at >= ?', Time.current.beginning_of_day).exists?
          flash[:alert] = "You can only purchase this daily offer once per day."
          redirect_to client_shop_index_path and return
        end
      end
      @order = Order.create(user: current_client_user, offer: @offer, amount: @offer.amount, coin: @offer.coin, genre: :deposit)
      @order.save
      flash[:notice] = "Offer purchased successfully!"
      redirect_to client_shop_index_path
    else
      flash[:alert] = "You must be signed in to purchase an offer. Please sign in first."
      redirect_to new_client_user_session_path
    end
  end

  private

  def set_offer
    @offer = Offer.find(params[:id])
  end
end