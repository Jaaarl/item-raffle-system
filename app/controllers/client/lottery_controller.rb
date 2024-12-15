class Client::LotteryController < ApplicationController
  before_action :set_lottery, only: [:show, :buy]

  def index
    @items = Item.includes(:categories).starting.active.order(created_at: :desc).page(params[:page]).per(12)
    if params[:category_id].present?
      @items = @items.joins(:categories).where(categories: { id: params[:category_id] })
    end
    @categories = Category.all
    @banners = Banner.active.where('online_at <= ? AND offline_at > ?', Date.current, Date.current).order(:sort)
    @news_tickers = NewsTicker.active.order(:sort)
  end

  def buy
    if current_client_user
      number_of_tickets = params[:counter].to_i

      if number_of_tickets > 0 && current_client_user.coins >= number_of_tickets
        number_of_tickets.times do
          @ticket = Ticket.create(user: current_client_user, item: @item)
          @ticket.save
        end
        flash[:notice] = t('notices.tickets_purchased', number_of_tickets: number_of_tickets)
      else
        if number_of_tickets < 0
          flash[:alert] = t('alerts.select_ticket')
        elsif current_client_user.coins < number_of_tickets
          flash[:alert] = t('alerts.not_enough_coins')
          redirect_to client_shop_index_path and return
        end
      end
      redirect_to client_lottery_path(id: @item.id)
    else
      flash[:alert] = t('alerts.sign_in_required')
      redirect_to new_client_user_session_path
    end
  end

  def show
    @user_ticket = Ticket.where(user: current_client_user, item: @item, batch_count: @item.batch_count)
  end

  private

  def set_lottery
    @item = Item.find(params[:id])
  end
end