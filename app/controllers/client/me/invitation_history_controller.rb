class Client::Me::InvitationHistoryController < ApplicationController
  def index
    @invited = User.where(parent: current_client_user).page(params[:page]).per(5)
  end
end