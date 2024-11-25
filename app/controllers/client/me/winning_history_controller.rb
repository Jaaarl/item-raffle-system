class Client::Me::WinningHistoryController < ApplicationController
  def index
    @winners = Winner.where(user: current_client_user).page(params[:page]).per(5)
  end
end