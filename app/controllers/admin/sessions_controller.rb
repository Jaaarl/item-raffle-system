class Admin::SessionsController < Devise::SessionsController
  def new
    super
  end

  def create
    self.resource = warden.authenticate!(auth_options)

    if resource.admin?
      set_flash_message!(:notice, :signed_in)
      sign_in(resource_name, resource)
      yield resource if block_given?
      respond_with resource, location: after_sign_in_path_for(resource)
    else
      sign_out(resource_name)
      set_flash_message!(:alert, :not_admin)
      redirect_to new_session_path(resource_name)
    end
  end

  def destroy
    super
  end

  def after_sign_in_path_for(resource)
    admin_dashboard_index_path
  end
  def after_sign_out_path_for(resource)
    new_admin_user_session_path
  end
end