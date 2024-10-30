class Admin::SessionsController < Devise::SessionsController
  def new
    super
  end

  def create
    super
  end

  def destroy
    super
  end

  def after_sign_in_path_for(resource)
    admins_path
  end
  def after_sign_out_path_for(resource)
    new_admin_user_session_path
  end
end