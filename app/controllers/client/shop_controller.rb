class Client::ShopController < ApplicationController
  before_action :set_offer, only: [:show, :buy]

  def index
    @offers = Offer.active
  end

  def show; end

  def buy
    if current_client_user
      if current_client_user.total_deposit >= @offer.amount
        @order = Order.create(user: current_client_user, offer: @offer)
        @order.save
        flash[:notice] = "Offer purchased successfully!"
      else
        flash[:alert] = "You don't have enough deposit to purchase this offer. Please add more amount to proceed"
      end
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