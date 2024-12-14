class Admin::TicketController < Admin::BaseController
  before_action :set_ticket, only: [:cancel]

  require 'csv'

  def index
    @tickets = Ticket.includes(:user, :item).order(created_at: :desc)

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

    all_tickets = @tickets
    @tickets = @tickets.page(params[:page]).per(10)

    respond_to do |format|
      format.html
      format.csv { send_data generate_csv(all_tickets), filename: "tickets-#{Date.today}.csv" }
    end
  end

  def cancel
    if @ticket.cancel!
      flash[:notice] = 'Item has been cancelled.'
    else
      flash[:alert] = 'Unable to cancel the item.'
    end
    redirect_to admin_ticket_index_path
  end

  private

  def set_ticket
    @ticket = Ticket.find(params[:id])
  end

  def generate_csv(tickets)
    CSV.generate(headers: true) do |csv|
      csv << ["Serial Number", "Item", "Email", "Batch Count", "Coins", "State", "Created At"]

      tickets.each do |ticket|
        csv << [
          ticket.serial_number,
          ticket.item.name,
          ticket.user.email,
          ticket.batch_count,
          ticket.coins,
          ticket.state,
          ticket.created_at.strftime('%b %d, %Y %I:%M %p')
        ]
      end
    end
  end
end