class Admin::OrderController < Admin::BaseController
  def index
    @orders = Order.includes(:offer).all

    @orders = @orders.where(serial_number: params[:serial_number]) if params[:serial_number].present?

    @orders = @orders.where("email LIKE ?", "%#{params[:email]}%") if params[:email].present?

    @orders = @orders.where(genre: params[:genre]) if params[:genre].present?

    @orders = @orders.where(state: params[:state] ) if params[:state].present?

    @orders = @orders.where(offers: { status: params[:offer] }) if params[:offer].present?

    @orders = @orders.where("created_at >= ?", Date.parse(params[:start_date])) if params[:start_date].present?

    @orders = @orders.where("created_at <= ?", Date.parse(params[:end_date])) if params[:end_date].present?
  end
end