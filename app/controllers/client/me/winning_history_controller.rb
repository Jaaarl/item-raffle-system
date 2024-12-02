class Client::Me::WinningHistoryController < ApplicationController
  before_action :set_winner, only: [:edit, :update]

  def index
    @winners = Winner.where(user: current_client_user).page(params[:page]).per(5).order(created_at: :desc)
  end

  def edit
    @locations = Location.where(user: current_client_user)
    @default_location = Location.find_by(user: current_client_user, is_default: true) || @locations.first
  end

  def update
    if @winner.update(winner_params)
      @winner.claim!
      redirect_to client_me_lottery_history_index_path, notice: 'Winning record updated successfully.'
    else
      render :edit, alert: 'Failed to update the winning record.'
    end
  end

  private

  def winner_params
    params.require(:winner).permit(:location_id)
  end

  def set_winner
    @winner = Winner.find(params[:id])
  end
end