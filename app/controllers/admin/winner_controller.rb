class Admin::WinnerController < Admin::BaseController
  def index
    @winners = Winner.includes(:user, :item, :ticket).all

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
end