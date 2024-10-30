# frozen_string_literal: true

class Client::RegistrationsController < Devise::RegistrationsController
  def after_sign_in_path_for(resource)
    clients_path
  end
end
