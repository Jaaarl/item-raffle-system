class Client::LotteryController < ApplicationController
  def index
    @items = Item.includes(:categories).where(state: 'starting', status: 'active')
    if params[:category_id].present?
      @items = @items.joins(:categories).where(categories: { id: params[:category_id] })
    end
    @categories = Category.all
  end
end