class Admin::ItemManagementController < Admin::BaseController
  before_action :set_item, only: [:show, :edit, :update, :destroy]
  def index
    @items = Item.includes(:categories).all
  end

  def show
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to admin_item_management_index_path, notice: 'Item was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @item.update(item_params)
      redirect_to admin_item_management_index_path, notice: 'Item was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @item.update(deleted_at: Time.current)
    redirect_to admin_item_management_index_path, notice: 'Item was successfully deleted.'
  end

  private

  def set_item
    @item = Item.find(params[:id])
  end

  def item_params
    params.require(:item).permit(
      :name,
      :quantity,
      :minimum_tickets,
      :state,
      :batch_count,
      :online_at,
      :offline_at,
      :start_at,
      :status,
      :image,
      category_ids: []
    )
  end
end