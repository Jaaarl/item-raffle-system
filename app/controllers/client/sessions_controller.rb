class Client::SessionsController < Devise::SessionsController
  def after_sign_in_path_for(resource)
    clients_path
  end
  def after_sign_out_path_for(resource)
    new_client_user_session_path
  end
end