class Admin::UserManagementController < Admin::BaseController
  before_action :set_user, only: [:show, :increase, :deduct, :bonus]

  require 'csv'

  def index
    @clients = User.includes(:parent, :children).where(role: 'client').order(created_at: :desc).page(params[:page]).per(10)
    @all_tickets = Ticket.includes(:user).all
    all_clients = User.where(role: 'client').order(created_at: :desc)
    respond_to do |format|
      format.html
      format.csv { send_data generate_csv(all_clients), filename: "clients-#{Date.today}.csv" }
    end
  end

  def show; end

  def increase
    if params[:coin].nil? || params[:coin].to_i == 0
      flash[:alert] = 'Coin amount cannot be nil or zero.'
      redirect_to admin_user_management_index_path and return
    end

    @increase = Order.create(user: @client, amount: 0, coin: params[:coin], remarks: params[:remarks], genre: :increase)
    if @increase.save
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

    @deduct = Order.create(user: @client, amount: 0, coin: params[:coin], remarks: params[:remarks], genre: :deduct)
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

  def bonus
    if params[:coin].nil? || params[:coin].to_i == 0
      flash[:alert] = 'Coin amount cannot be nil or zero.'
      redirect_to admin_user_management_index_path and return
    end

    @bonus = Order.create(user: @client, amount: 0, coin: params[:coin], genre: :bonus)
    if @bonus.save
      @bonus.pay!
      redirect_to admin_user_management_index_path, notice: 'Bonus successfully added to the user.'
    else
      if @bonus.errors.any?
        flash[:alert] = @bonus.errors.full_messages.to_sentence
      end
      redirect_to admin_user_management_index_path
    end
  end

  private

  def set_user
    @client = User.find(params[:id])
  end

  private

  def generate_csv(clients)
    CSV.generate(headers: true) do |csv|
      csv << ['Parent Email', 'Email', 'Total Deposit', 'Member Total Deposits', 'Coins', 'Total Used Coins', 'Children Members', 'Phone Number']

      clients.each do |client|
        csv << [
          client.parent&.email,
          client.email,
          client.total_deposit || 0,
          client.children.sum(:total_deposit),
          client.coins || 0,
          @all_tickets.where(user: client).count,
          client.children_members || 0,
          client.phone
        ]
      end
    end
  end
end