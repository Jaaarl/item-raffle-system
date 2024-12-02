# frozen_string_literal: true
class Client::LocationController < ApplicationController
  before_action :set_location, only: [:show, :edit, :update, :destroy, :make_default]

  def index
    @locations = Location.where(user_id: current_client_user.id).order(created_at: :desc)
  end

  def show
  end

  def new
    @location = Location.new
  end

  def create
    @location = Location.new(location_params)
    @location.user = current_client_user
    if @location.save
      redirect_to client_location_index_path, notice: 'Address was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @location.update(location_params)
      redirect_to client_location_index_path, notice: 'Address was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @location.destroy
    redirect_to client_location_index_path, notice: 'Address was successfully destroyed.'
  end

  def make_default
    @location.update(is_default: true)

    @location.user.locations.where.not(id: @location.id).update_all(is_default: false)

    redirect_to client_location_index_path, notice: 'Address was successfully set as default.'
  end

  private

  def set_location
    @location = Location.find(params[:id])
  end

  def location_params
    params.require(:location).permit(
      :genre, :name, :street_address, :phone_number,
      :remark, :is_default, :user_id,
      :address_region_id, :address_province_id,
      :address_city_id, :address_barangay_id
    )
  end
end
