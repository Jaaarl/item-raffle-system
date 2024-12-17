class Admin::BannerController < Admin::BaseController
  before_action :set_banner, only: [:show, :edit, :update, :destroy]

  def index
    @banners = Banner.all.order(:sort).page(params[:page]).per(10)
  end

  def show; end

  def new
    @banner = Banner.new
  end

  def create
    @banner = Banner.new(news_ticker_params)
    if @banner.save
      redirect_to admin_banner_index_path, notice: 'Banner was successfully created.'
    else
      if @banner.errors.any?
        flash[:alert] = @banner.errors.full_messages.to_sentence
      end
      render :new
    end
  end

  def edit; end

  def update
    if @banner.update(news_ticker_params)
      redirect_to admin_banner_index_path, notice: 'Banner was successfully updated.'
    else
      if @banner.errors.any?
        flash[:alert] = @banner.errors.full_messages.to_sentence
      end
      render :edit
    end
  end

  def destroy
    @banner.destroy
    redirect_to admin_banner_index_path, notice: 'Banner was successfully deleted.'
  end

  private

  def set_banner
    @banner = Banner.find(params[:id])
  end

  def news_ticker_params
    params.require(:banner).permit(:image, :online_at, :offline_at, :status, :sort)
  end
end