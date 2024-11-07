# frozen_string_literal: true
class Client::PlaceController < ApplicationController
  before_action :set_place, only: [:show, :edit, :update, :destroy]

  def index
    @places = Place.all
  end

  def show
  end

  def new
    @place = Place.new
  end

  def create
    @place = Place.new(place_params)
    @place.user = User.first
    if @place.save
      redirect_to client_place_index_path, notice: 'Place was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @place.update(place_params)
      redirect_to client_place_index_path, notice: 'Place was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @place.destroy
    redirect_to client_place_index_path, notice: 'Place was successfully destroyed.'
  end

  private

  def set_place
    @place = Place.find(params[:id])
  end

  def place_params
    params.require(:place).permit(
      :genre, :name, :street_address, :phone_number,
      :remark, :is_default, :user_id,
      :address_region_id, :address_province_id,
      :address_city_id, :address_barangay_id
    )
  end
end
