class Admin::UserManagementController < Admin::BaseController
  before_action :set_user, only: [:show]

  def index
    @clients = User.where(role: 'client')
  end

  def show

  end

  def set_user
    @client = User.find(params[:id])
  end
end