class Admin::TicketController < Admin::BaseController
  def index
    @ticket = Ticket.includes(:user, :item).all
  end
end