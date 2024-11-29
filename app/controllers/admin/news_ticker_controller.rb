class Admin::NewsTickerController < Admin::BaseController
  before_action :set_news_ticker, only: [:show, :edit, :update, :destroy]

  def index
    @news_tickers = NewsTicker.all
  end

  def show
  end

  def new
    @news_ticker = NewsTicker.new
  end

  def create
    @news_ticker = NewsTicker.new(news_ticker_params)
    @news_ticker.admin = current_admin_user
    if @news_ticker.save
      redirect_to admin_news_ticker_index_path, notice: 'News ticker was successfully created.'
    else
      if @news_ticker.errors.any?
        flash[:alert] = @news_ticker.errors.full_messages.to_sentence
      end
      render :new
    end
  end

  def edit
  end

  def update
    if @news_ticker.update(news_ticker_params)
      redirect_to admin_news_ticker_path(@news_ticker), notice: 'News ticker was successfully updated.'
    else
      if @news_ticker.errors.any?
        flash[:alert] = @news_ticker.errors.full_messages.to_sentence
      end
      render :edit
    end
  end

  def destroy
    @news_ticker.destroy
    redirect_to admin_news_ticker_index_path, notice: 'News ticker was successfully deleted.'
  end

  private

  def set_news_ticker
    @news_ticker = NewsTicker.find(params[:id])
  end

  def news_ticker_params
    params.require(:news_ticker).permit(:status, :content)
  end
end