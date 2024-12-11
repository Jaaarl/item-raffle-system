# frozen_string_literal: true

class Client::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]

  def after_sign_in_path_for(resource)
    client_homepage_index_path
  end

  def new
    cookies[:promoter] = params[:promoter]
    super
  end

  def create
    build_resource(sign_up_params)
    resource.save
    yield resource if block_given?
    if resource.persisted?
      if resource.active_for_authentication?
        set_flash_message! :notice, :signed_up
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
        promoter_name = cookies[:promoter]
        promoter = User.find_by(email: promoter_name)
        promoter.current_invite_counter += 1
        next_level = promoter.member_level.level + 1
        next_level_content = MemberLevel.find_by(level: next_level)
        if next_level_content
          if next_level_content.required_members <= promoter.current_invite_counter
            order = Order.create(user: promoter, amount: 0, coin: next_level_content.coins, genre: :member_level)
            order.save
            order.pay!
            promoter.member_level = next_level_content
            promoter.current_invite_counter = 0
          end
        end
        promoter.save
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      if resource.errors.any?
        flash[:alert] = resource.errors.full_messages.to_sentence
      end
      respond_with resource
    end
  end

  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    resource_updated = update_resource(resource, account_update_params)
    yield resource if block_given?
    if resource_updated
      set_flash_message_for_update(resource, prev_unconfirmed_email)
      flash[:notice] = 'User profile has been updated successfully.'
      bypass_sign_in resource, scope: resource_name if sign_in_after_change_password?
      redirect_to client_me_index_path
    else
      clean_up_passwords resource
      set_minimum_password_length
      if resource.errors.any?
        flash[:alert] = resource.errors.full_messages.to_sentence
      end

      redirect_to edit_client_user_registration_path
    end
  end

  protected

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :parent_id])
  end

  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:phone, :username, :image])
  end
end
