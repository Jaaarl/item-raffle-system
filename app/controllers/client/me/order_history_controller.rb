class Client::Me::OrderHistoryController < ApplicationController
  def index
    @orders = Order.where(user: current_client_user).page(params[:page]).per(5)
  end
end