# frozen_string_literal: true

class Client::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  def after_sign_in_path_for(resource)
    client_homepage_index_path
  end

  protected
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
  end
end
