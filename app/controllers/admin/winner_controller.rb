class Admin::WinnerController < Admin::BaseController
  before_action :set_winner, only: [:submit, :pay, :ship, :deliver, :publish, :remove_publish]
  def index
    @winners = Winner.includes(:user, :item, :ticket).all.order(created_at: :desc)

    @winners = @winners.where(serial_number: params[:serial_number]) if params[:serial_number].present?

    @winners = @winners.joins(:item).where('items.name LIKE ?', "%#{params[:item_name]}%") if params[:item_name].present?

    @winners = @winners.joins(:user).where('users.email LIKE ?', "%#{params[:email]}%") if params[:email].present?

    @winners = @winners.where(state: params[:state]) if params[:state].present?

    if params[:start_date].present? && params[:end_date].present?
      @winners = @winners.where(created_at: params[:start_date]..params[:end_date])
    elsif params[:start_date].present?
      @winners = @winners.where('created_at >= ?', params[:start_date])
    elsif params[:end_date].present?
      @winners = @winners.where('created_at <= ?', params[:end_date])
    end
  end

  def submit
    if @winner.submit!
      redirect_to admin_winner_index_path, notice: 'Winner has been submitted.'
    else
      redirect_to admin_winner_index_path, alert: 'Unable to submit the winner.'
    end
  end

  def pay
    @winner.admin = current_admin_user
    if @winner.pay!
      redirect_to admin_winner_index_path, notice: 'Admin has paid the item.'
    else
      redirect_to admin_winner_index_path, alert: 'Unable to pay the item.'
    end
  end

  def ship
    if @winner.ship!
      redirect_to admin_winner_index_path, notice: 'Admin has shipped the item.'
    else
      redirect_to admin_winner_index_path, alert: 'Unable to shipped the item.'
    end
  end

  def deliver
    if @winner.deliver!
      redirect_to admin_winner_index_path, notice: 'Item has been delivered.'
    else
      redirect_to admin_winner_index_path, alert: 'Unable to deliver the item.'
    end
  end

  def publish
    if @winner.publish!
      redirect_to admin_winner_index_path, notice: 'Feedback has been publish.'
    else
      redirect_to admin_winner_index_path, alert: 'Unable to publish the item.'
    end
  end

  def remove_publish
    if @winner.remove_publish!
      redirect_to admin_winner_index_path, notice: 'Feedback has been unpublish.'
    else
      redirect_to admin_winner_index_path, alert: 'Unable to unpublish the item.'
    end
  end

  private

  def set_winner
    @winner = Winner.find(params[:id])
  end
end