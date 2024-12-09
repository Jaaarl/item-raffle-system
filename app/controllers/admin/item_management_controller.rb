class Admin::ItemManagementController < Admin::BaseController
  before_action :set_item, only: [:edit, :update, :destroy, :show, :start, :pause, :end, :cancel]

  def index
    @items = Item.includes(:categories).all.order(created_at: :desc).page(params[:page]).per(10)
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
      if @offer.errors.any?
        flash[:alert] = @offer.errors.full_messages.to_sentence
      end
      render :edit
    end
  end

  def destroy
    tickets = Ticket.find_by(item_id: @item.id)
    if tickets
      flash[:notice] = 'Cannot delete item. This item has associated tickets.'
    else
      @item.destroy!
      flash[:notice] = 'Item was successfully deleted.'
    end
    redirect_to admin_item_management_index_path
  end

  def start
    if @item.start!
      flash[:notice] = 'Item has been started.'
    else
      flash[:alert] = 'Unable to start the item.'
    end
    redirect_to admin_item_management_index_path
  end

  def pause
    if @item.pause!
      flash[:notice] = 'Item has been paused.'
    else
      flash[:alert] = 'Unable to pause the item.'
    end
    redirect_to admin_item_management_index_path
  end

  def end
    if @item.end!
      flash[:notice] = 'Item has been ended.'
    else
      flash[:alert] = 'Unable to end the item.'
    end
    redirect_to admin_item_management_index_path
  end

  def cancel
    if @item.cancel!
      flash[:notice] = 'Item has been cancelled.'
    else
      flash[:alert] = 'Unable to cancel the item.'
    end
    redirect_to admin_item_management_index_path
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