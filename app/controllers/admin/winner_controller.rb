class Admin::WinnerController < Admin::BaseController
  before_action :set_winner, only: [:submit, :pay, :ship, :deliver, :publish, :remove_publish]

  def index
    @winners = Winner.includes(:user, :item, :ticket).order(created_at: :desc).page(params[:page]).per(10)

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
      flash[:notice] = 'Winner has been submitted.'
    else
      flash[:alert] = 'Unable to submit the winner.'
    end
    redirect_to admin_winner_index_path
  end

  def pay
    @winner.admin = current_admin_user
    if @winner.pay!
      flash[:notice] = 'Admin has paid the item.'
    else
      flash[:alert] = 'Unable to pay the item.'
    end
    redirect_to admin_winner_index_path
  end

  def ship
    if @winner.ship!
      flash[:notice] = 'Admin has shipped the item.'
    else
      flash[:alert] = 'Unable to ship the item.'
    end
    redirect_to admin_winner_index_path
  end

  def deliver
    if @winner.deliver!
      flash[:notice] = 'Item has been delivered.'
    else
      flash[:alert] = 'Unable to deliver the item.'
    end
    redirect_to admin_winner_index_path
  end

  def publish
    if @winner.publish!
      flash[:notice] = 'Feedback has been published.'
    else
      flash[:alert] = 'Unable to publish the item.'
    end
    redirect_to admin_winner_index_path
  end

  def remove_publish
    if @winner.remove_publish!
      flash[:notice] = 'Feedback has been unpublished.'
    else
      flash[:alert] = 'Unable to unpublish the item.'
    end
    redirect_to admin_winner_index_path
  end

  private

  def set_winner
    @winner = Winner.find(params[:id])
  end
end