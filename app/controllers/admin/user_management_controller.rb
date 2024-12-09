class Admin::UserManagementController < Admin::BaseController
  before_action :set_user, only: [:show, :increase, :deduct]

  def index
    @clients = User.where(role: 'client').order(created_at: :desc).page(params[:page]).per(10)
  end

  def show

  end

  def increase
    if params[:coin].nil? || params[:coin].to_i == 0
      flash[:alert] = 'Coin amount cannot be nil or zero.'
      redirect_to admin_user_management_index_path and return
    end

    @increase = Order.create(user: @client, amount: 0, coin: params[:coin], genre: "increase")
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

    @deduct = Order.create(user: @client, amount: 0, coin: params[:coin], genre: "deduct")
    if @deduct.save
      @deduct.submit!
      if @deduct.may_pay? && @client.coins >= @deduct.coin
        @deduct.pay!
        flash[:notice] = 'Deduct successfully added to the user.'
      else
        @deduct.cancel!
        flash[:alert] = 'Cannot deduct coins resulting in a negative balance.'
      end
    else
      if @deduct.errors.any?
        flash[:alert] = @deduct.errors.full_messages.to_sentence
      end
    end
    redirect_to admin_user_management_index_path
  end

  private

  def set_user
    @client = User.find(params[:id])
  end
end