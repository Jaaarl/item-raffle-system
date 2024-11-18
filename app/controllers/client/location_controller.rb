# frozen_string_literal: true
class Client::LocationController < ApplicationController
  before_action :set_location, only: [:show, :edit, :update, :destroy]

  def index
    @locations = Location.where(user_id: current_client_user.id)
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
      redirect_to client_location_index_path, notice: 'Place was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @location.update(location_params)
      redirect_to client_location_index_path, notice: 'Place was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @location.destroy
    redirect_to client_location_index_path, notice: 'Place was successfully destroyed.'
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
