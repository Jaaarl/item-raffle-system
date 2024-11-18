class Admin::TicketController < Admin::BaseController
  before_action :set_ticket, only: [:cancel]

  def index
    @tickets = Ticket.includes(:user, :item).all

    @tickets = @tickets.where(serial_number: params[:serial_number]) if params[:serial_number].present?

    @tickets = @tickets.joins(:item).where('items.name LIKE ?', "%#{params[:item_name]}%") if params[:item_name].present?

    @tickets = @tickets.joins(:user).where('users.email LIKE ?', "%#{params[:email]}%") if params[:email].present?

    @tickets = @tickets.where(state: params[:state]) if params[:state].present?

    if params[:start_date].present? && params[:end_date].present?
      @tickets = @tickets.where(created_at: params[:start_date]..params[:end_date])
    elsif params[:start_date].present?
      @tickets = @tickets.where('created_at >= ?', params[:start_date])
    elsif params[:end_date].present?
      @tickets = @tickets.where('created_at <= ?', params[:end_date])
    end
  end

  def cancel
    if @ticket.cancel!
      redirect_to admin_ticket_index_path, notice: 'Item has been cancelled.'
    else
      redirect_to admin_ticket_index_path, alert: 'Unable to cancel the item.'
    end
  end

  private

  def set_ticket
    @ticket = Ticket.find(params[:id])
  end
end