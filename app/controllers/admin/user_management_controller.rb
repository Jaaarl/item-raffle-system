class Admin::UserManagementController < Admin::BaseController
  def index
    @clients = User.where(role: 'client')
  end
end