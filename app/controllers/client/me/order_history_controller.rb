class Client::Me::OrderHistoryController < ApplicationController
  before_action :set_order, only: [:cancel]

  def index
    @orders = Order.where(user: current_client_user).page(params[:page]).per(5)
  end

  def cancel
    @order.cancel!
    redirect_to client_me_order_history_index_path, notice: 'Order cancelled successfully.'
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end
end