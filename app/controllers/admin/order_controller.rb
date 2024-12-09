class Admin::OrderController < Admin::BaseController
  before_action :set_order, only: [:cancel, :pay, :submit]

  def index
    @orders = Order.includes(:offer)

    @orders = @orders.where(serial_number: params[:serial_number]) if params[:serial_number].present?

    @orders = @orders.joins(:user).where("email LIKE ?", "%#{params[:email]}%") if params[:email].present?

    @orders = @orders.where(genre: params[:genre]) if params[:genre].present?

    @orders = @orders.where(state: params[:state]) if params[:state].present?

    @orders = @orders.where(offers: { status: params[:offer] }) if params[:offer].present?

    @orders = @orders.where("created_at >= ?", Date.parse(params[:start_date])) if params[:start_date].present?

    @orders = @orders.where("created_at <= ?", Date.parse(params[:end_date])) if params[:end_date].present?

    @orders = @orders.order(created_at: :desc).page(params[:page]).per(10)

    @all_orders = Order.includes(:offer).all
  end

  def pay
    if @order.pay!
      flash[:notice] = 'Order has been paid.'
    else
      flash[:alert] = 'Unable to pay the order.'
    end
    redirect_to admin_order_index_path
  end

  def cancel
    if @order.cancel!
      redirect_to admin_order_index_path, notice: 'Order has been cancelled.'
    else
      redirect_to admin_order_path, alert: 'Unable to cancel the order.'
    end
  end

  def submit
    if @order.submit!
      flash[:notice] = 'Order has been Submitted.'
    else
      flash[:alert] = 'Unable to submit the order.'
    end
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end
end