class Client::LotteryController < ApplicationController
  before_action :set_lottery, only: [:show]

  def index
    @items = Item.includes(:categories).where(state: 'starting', status: 'active')
    if params[:category_id].present?
      @items = @items.joins(:categories).where(categories: { id: params[:category_id] })
    end
    @categories = Category.all
  end

  def show
  end

  private

  def set_lottery
    @item = Item.find(params[:id])
  end
end