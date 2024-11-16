class Admin::TicketController < Admin::BaseController
  before_action :set_ticket, only: [:cancel]
  def index
    @ticket = Ticket.includes(:user, :item).all
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