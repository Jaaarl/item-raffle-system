class Client::Me::ShareController < ApplicationController
  before_action :set_winner, only: [:edit, :update]

  def edit; end

  def update
    if @winner.update(winner_params)
      @winner.share!
      @order = Order.create(user: current_client_user, amount: 0, coin: 1, genre: :share)
      @order.save
      @order.pay!
      redirect_to client_me_winning_history_index_path, notice: 'Feedback submitted successfully.'
    else
      render :edit, alert: 'There was an error submitting your feedback. Please try again.'
    end
  end

  private

  def winner_params
    params.require(:winner).permit(:image, :comment)
  end

  def set_winner
    @winner = Winner.find(params[:id])
  end
end