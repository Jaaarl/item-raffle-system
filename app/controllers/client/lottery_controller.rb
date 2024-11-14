class Client::LotteryController < ApplicationController
  def index
    @items = Item.all
    @categories = Category.all
  end
end