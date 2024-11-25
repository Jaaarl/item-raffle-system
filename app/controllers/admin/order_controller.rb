class Admin::OrderController < Admin::BaseController
  before_action :set_order, only: [:cancel, :pay]

  def index
    @orders = Order.includes(:offer).page(params[:page]).per(5)

    @orders = @orders.where(serial_number: params[:serial_number]) if params[:serial_number].present?

    @orders = @orders.where("email LIKE ?", "%#{params[:email]}%") if params[:email].present?

    @orders = @orders.where(genre: params[:genre]) if params[:genre].present?

    @orders = @orders.where(state: params[:state]) if params[:state].present?

    @orders = @orders.where(offers: { status: params[:offer] }) if params[:offer].present?

    @orders = @orders.where("created_at >= ?", Date.parse(params[:start_date])) if params[:start_date].present?

    @orders = @orders.where("created_at <= ?", Date.parse(params[:end_date])) if params[:end_date].present?
  end

  def pay
    if @order.pay!
      redirect_to admin_order_index_path, notice: 'Order has been paid.'
    else
      redirect_to admin_order_index_path, alert: 'Unable to pay the order.'
    end
  end

  def cancel
    if @order.cancel!
      redirect_to admin_order_index_path, notice: 'Order has been cancelled.'
    else
      redirect_to admin_order_path, alert: 'Unable to cancel the order.'
    end
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end
end