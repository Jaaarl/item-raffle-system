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
          flash[:alert] = t('alerts.already_purchased_one_time_offer')
          redirect_to client_shop_index_path and return
        end
      elsif @offer.monthly?
        if Order.exists?(user: current_client_user, offer: @offer, state: [:pending, :submitted, :paid]) ||
          Order.where(user: current_client_user, offer: @offer).where('created_at >= ?', Time.current.beginning_of_month).exists?
          flash[:alert] = t('alerts.purchase_limit_monthly')
          redirect_to client_shop_index_path and return
        end
      elsif @offer.weekly?
        if Order.exists?(user: current_client_user, offer: @offer, state: [:pending, :submitted, :paid]) ||
          Order.where(user: current_client_user, offer: @offer).where('created_at >= ?', Time.current.beginning_of_week).exists?
          flash[:alert] = t('alerts.purchase_limit_weekly')
          redirect_to client_shop_index_path and return
        end
      elsif @offer.daily?
        if Order.exists?(user: current_client_user, offer: @offer, state: [:pending, :submitted, :paid]) ||
          Order.where(user: current_client_user, offer: @offer).where('created_at >= ?', Time.current.beginning_of_day).exists?
          flash[:alert] = t('alerts.purchase_limit_daily')
          redirect_to client_shop_index_path and return
        end
      end
      @order = Order.create(user: current_client_user, offer: @offer, amount: @offer.amount, coin: @offer.coin, genre: :deposit)
      @order.save
      flash[:notice] = t('notices.offer_purchased')
      redirect_to client_shop_index_path
    else
      flash[:alert] = t('alerts.sign_in_required_shop')
      redirect_to new_client_user_session_path
    end
  end

  private

  def set_offer
    @offer = Offer.find(params[:id])
  end
end