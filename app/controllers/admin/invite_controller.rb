class Admin::InviteController < Admin::BaseController

  require 'csv'

  def index
    @clients = User.includes(:parent, :children, :member_level).where(role: 'client').where.not(parent: nil)
                   .order(created_at: :desc).page(params[:page]).per(10)

    @clients = @clients.joins('LEFT OUTER JOIN `users` `parent` ON `parent`.`id` = `users`.`parent_id`')
                       .where('parent.email LIKE ?', "%#{params[:parent_email]}%") if params[:parent_email].present?
    @all_tickets = Ticket.includes(:user).all

    all_clients = User.includes(:parent, :children, :member_level).where(role: 'client')
                      .where.not(parent: nil).order(created_at: :desc)
    all_clients = all_clients.joins('LEFT OUTER JOIN `users` `parent` ON `parent`.`id` = `users`.`parent_id`')
                             .where('parent.email LIKE ?', "%#{params[:parent_email]}%") if params[:parent_email].present?

    respond_to do |format|
      format.html
      format.csv { send_data generate_csv(all_clients), filename: "invite_list-#{Date.today}.csv" }
    end
  end

  private

  def generate_csv(clients)
    CSV.generate(headers: true) do |csv|
      csv << ['Parent Level', 'Parent Email', 'Email', 'Total Deposit', 'Member Total Deposits', 'Coins', 'Total Used Coins', 'Children Members', 'Created at']

      clients.each do |client|
        csv << [
          client.parent_id.blank? ? "N/A" : client.parent.member_level.level,
          client.parent_id.blank? ? "N/A" : client.parent.email,
          client.email,
          client.total_deposit || 0,
          client.children.sum(:total_deposit),
          client.coins || 0,
          @all_tickets.where(user: client).count,
          client.children_members || 0,
          client.created_at.strftime("%B %d, %Y at %I:%M %p")
        ]
      end
    end
  end
end