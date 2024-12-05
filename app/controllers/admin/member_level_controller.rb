class Admin::MemberLevelController < Admin::BaseController
  before_action :set_member_level, only: [:edit, :update]

  def index
    @member_levels = MemberLevel.all.page(params[:page]).per(10)
  end

  def show
  end

  def new
    @member_level = MemberLevel.new
    @member_levels_count = MemberLevel.count + 1
  end

  def create
    @member_level = MemberLevel.new(member_levels_params)
    @member_level.level = MemberLevel.count + 1
    if @member_level.save
      redirect_to admin_member_level_index_path, notice: 'Member level was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @member_level.update(member_levels_params)
      redirect_to admin_member_level_index_path, notice: 'Member level was successfully updated.'
    else
      if @member_level.errors.any?
        flash[:alert] = @member_level.errors.full_messages.to_sentence
      end
      render :edit
    end
  end

  private

  def set_member_level
    @member_level = MemberLevel.find(params[:id])
  end

  def member_levels_params
    params.require(:member_level).permit(
      :level,
      :required_members,
      :coins
    )
  end
end