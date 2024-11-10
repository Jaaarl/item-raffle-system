class Client::SessionsController < Devise::SessionsController
  def create
    self.resource = warden.authenticate!(auth_options)

    if resource.client?
      set_flash_message!(:notice, :signed_in)
      sign_in(resource_name, resource)
      yield resource if block_given?
      respond_with resource, location: after_sign_in_path_for(resource)
    else
      sign_out(resource_name)
      set_flash_message!(:alert, :not_client)
      redirect_to new_session_path(resource_name)
    end
  end
  
  def after_sign_in_path_for(resource)
    client_homepage_index_path
  end
  def after_sign_out_path_for(resource)
    new_client_user_session_path
  end
end