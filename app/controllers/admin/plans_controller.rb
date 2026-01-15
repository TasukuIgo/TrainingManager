class Admin::PlansController < ApplicationController

  before_action :set_plan, only: [:edit, :update, :destroy]
  before_action :load_training_schedules, only: [:new, :create, :edit, :update]

  def new
    @plan = Plan.new
  end

  def create
    @plan = Plan.new(plan_params)

    # チェックした研修スケジュールIDを一時保持
    @plan.selected_training_schedule_ids =
      params[:plan][:training_schedule_ids]&.reject(&:blank?) || []

    if @plan.save
      # 中間テーブルに紐付けて保存（既存仕様を維持）
      @plan.training_schedules =
        TrainingSchedule.where(id: @plan.selected_training_schedule_ids)

      redirect_to admin_plans_path,
                  notice: "プランを作成しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  # 一覧
  def index
    @plans = Plan.all
  end

  # 編集
  def edit
    # 既存プランのチェック状態を復元（超重要）
    @plan.selected_training_schedule_ids =
      @plan.training_schedule_ids
  end

  def update
    @plan.selected_training_schedule_ids =
      params[:plan][:training_schedule_ids]&.reject(&:blank?) || []

    if @plan.update(plan_params)
      @plan.training_schedules =
        TrainingSchedule.where(id: @plan.selected_training_schedule_ids)

      redirect_to admin_plans_path,
                  notice: "プランを更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # 削除（Edit からのみ呼ばれる想定）
  def destroy
    @plan.destroy
    redirect_to admin_plans_path,
                notice: "プランを削除しました"
  end

  private

  # 🔹 LoadMaster（共通化）
  def load_training_schedules
    @training_schedules =
      TrainingSchedule
        .where('start_time >= ?', Time.zone.now.beginning_of_day)
        .order(start_time: :asc)
  end

  def set_plan
    @plan = Plan.find(params[:id])
  end

  def plan_params
    params.require(:plan).permit(:name, :description, training_schedule_ids: [], user_ids: [])
  end
end
