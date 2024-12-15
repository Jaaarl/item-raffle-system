class Admin::OfferController < Admin::BaseController
  before_action :set_offer, only: [:show, :edit, :update, :destroy]

  def index
    @offers = Offer.all.order(created_at: :desc).page(params[:page]).per(10)

    if params[:status].present?
      @offers = Offer.where(status: params[:status]).page(params[:page]).per(10)
    end
  end

  def show; end

  def new
    @offer = Offer.new
  end

  def create
    @offer = Offer.new(offer_params)
    if @offer.save
      redirect_to admin_offer_index_path, notice: 'Offer was successfully created.'
    else
      if @offer.errors.any?
        flash[:alert] = @offer.errors.full_messages.to_sentence
      end
      render :new
    end
  end

  def edit
  end

  def update
    if @offer.update(offer_params)
      redirect_to admin_offer_path(@offer), notice: 'Offer was successfully updated.'
    else
      if @offer.errors.any?
        flash[:alert] = @offer.errors.full_messages.to_sentence
      end
      render :edit
    end
  end

  def destroy
    @offer.destroy
    redirect_to admin_offer_index_path, notice: 'Offer was successfully deleted.'
  end

  private

  def set_offer
    @offer = Offer.find(params[:id])
  end

  def offer_params
    params.require(:offer).permit(:name, :status, :amount, :coin, :image, :genre)
  end
end