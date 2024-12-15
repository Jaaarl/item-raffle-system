class Admin::BaseController < ActionController::Base
  before_action :authenticate_admin_user!
  before_action :set_locale

  layout 'admin'

  private

  def set_locale
    if params[:locale] && I18n.available_locales.include?(params[:locale].to_sym)
      session[:locale] = params[:locale]
    end

    I18n.locale = session[:locale] || I18n.default_locale
  end
end