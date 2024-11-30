class Admin::BalanceController < Admin::BaseController
  before_action :set_user, only: [:show, :edit, :increase, :deduct]

  def increase
    if params[:coin].nil? || params[:coin].to_i == 0
      flash[:alert] = 'Coin amount cannot be nil or zero.'
      redirect_to admin_user_management_index_path and return
    end

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

  def deduct
    if params[:coin].nil? || params[:coin].to_i == 0
      flash[:alert] = 'Coin amount cannot be nil or zero.'
      redirect_to admin_user_management_index_path and return
    end

    @increase = Order.create(user: @user, amount: 0, coin: params[:coin], genre: "deduct")
    if @increase.save
      @increase.submit!
      @increase.pay!
      redirect_to admin_user_management_index_path, notice: 'Deduct successfully added to the user.'
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