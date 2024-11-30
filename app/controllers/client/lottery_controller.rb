class Client::LotteryController < ApplicationController
  before_action :set_lottery, only: [:show, :buy]

  def index
    @items = Item.includes(:categories).starting.active
    if params[:category_id].present?
      @items = @items.joins(:categories).where(categories: { id: params[:category_id] })
    end
    @categories = Category.all
    @banners = Banner.active.where('online_at <= ? AND offline_at > ?', Date.current, Date.current)
  end

  def buy
    if current_client_user
      number_of_tickets = params[:counter].to_i

      if number_of_tickets > 0 && current_client_user.coins >= number_of_tickets
        number_of_tickets.times do
          @ticket = Ticket.create(user: current_client_user, item: @item)
          @ticket.save
        end
        flash[:notice] = "#{number_of_tickets} tickets purchased successfully!"
      else
        if number_of_tickets < 0
          flash[:alert] = "Please select at least one ticket."
        elsif current_client_user.coins < number_of_tickets
          flash[:alert] = "You don't have enough coins to purchase this ticket. Please add more coins to proceed"
        end
      end
      redirect_to client_lottery_path(id: @item.id)
    else
      flash[:alert] = "You must be signed in to purchase a ticket. Please sign in first."
      redirect_to new_client_user_session_path
    end
  end

  def show
  end

  private

  def set_lottery
    @item = Item.find(params[:id])
  end
end