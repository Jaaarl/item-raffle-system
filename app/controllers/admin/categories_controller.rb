class Admin::CategoriesController < Admin::BaseController
  before_action :set_category, only: [:show, :edit, :update, :destroy]

  def index
    @categories = Category.all.order(:sort).page(params[:page]).per(10)
  end

  def show; end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to admin_categories_path, notice: 'Category was successfully created.'
    else
      if @category.errors.any?
        flash[:alert] = @category.errors.full_messages.to_sentence
      end
      render :new
    end
  end

  def edit; end

  def update
    if @category.update(category_params)
      redirect_to admin_categories_path, notice: 'Category was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    if @category.destroy
      flash[:notice] = 'Category was successfully deleted.'
    else
      flash[:alert] = 'Cannot delete category with associated posts.'
    end
    redirect_to admin_categories_path
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name, :sort)
  end
end
