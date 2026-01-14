class Admin::PlansController < ApplicationController

  def new
    @plan = Plan.new
    @training_schedules = TrainingSchedule.all
  end

  def create
    @plan = Plan.new(plan_params)
    # チェックした研修スケジュールIDをセット
    @plan.selected_training_schedule_ids = params[:plan][:training_schedule_ids].reject(&:blank?)

    if @plan.save
      # 中間テーブルに紐付けて保存
      @plan.training_schedules = TrainingSchedule.where(id: @plan.selected_training_schedule_ids)
      redirect_to admin_plans_path, notice: "プランを作成しました"
    else
      @training_schedules = TrainingSchedule.all
      render :new
    end
  end


  def index
    @plans = Plan.all
  end

  def show
  end

  def edit
  end

  private

  def plan_params
    params.require(:plan).permit(:name, :description, :participants)
  end
end