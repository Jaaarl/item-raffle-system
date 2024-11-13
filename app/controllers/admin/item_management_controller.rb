class Admin::ItemManagementController < Admin::BaseController
  before_action :set_item, only: [:edit, :update, :destroy, :show, :start, :pause, :end, :cancel]
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

  def start
    if @item.start!
      redirect_to admin_item_management_index_path, notice: 'Item has been started.'
    else
      redirect_to admin_item_management_index_path, alert: 'Unable to start the item.'
    end
  end

  def pause
    if @item.pause!
      redirect_to admin_item_management_index_path, notice: 'Item has been paused.'
    else
      redirect_to admin_item_management_index_path, alert: 'Unable to pause the item.'
    end
  end

  def end
    if @item.end!
      redirect_to admin_item_management_index_path, notice: 'Item has been ended.'
    else
      redirect_to admin_item_management_index_path, alert: 'Unable to end the item.'
    end
  end

  def cancel
    if @item.cancel!
      redirect_to admin_item_management_index_path, notice: 'Item has been cancelled.'
    else
      redirect_to admin_item_management_index_path, alert: 'Unable to cancel the item.'
    end
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