class AdminsController < ApplicationController
  before_action :authenticate_admin_user!
  before_action :check_admin
  def index; end

  def check_admin
    raise ActionController::RoutingError.new('Not Found') unless current_admin_user.admin?
  end
end