class Admin::BalanceController < Admin::BaseController
  before_action :set_user, only: [:show, :edit, :increase]

  def increase
    @increase = Order.create(user: @user, amount: 0, coin: params[:coin], genre: "increase")
    if @increase.save
      @increase.submit!
      @increase.pay!
      redirect_to admin_user_management_index_path, notice: 'Increase successfully added to the user.'
    else
      if @increase.errors.any?
        flash[:alert] = @increase.errors.full_messages.to_sentence
      end
      redirect_to admin_user_management_index_path
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end