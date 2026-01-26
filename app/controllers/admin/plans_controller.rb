class Admin::PlansController < ApplicationController
  # ログインしていないとアクセスできない
  before_action :require_login
  # 編集・更新・削除のときに対象プランを取得
  before_action :set_plan, only: [:edit, :update, :destroy]
  # 新規作成・編集のフォームで使う研修スケジュールを読み込む
  before_action :load_training_schedules, only: [:new, :create, :edit, :update]

  # 新規作成フォーム
  def new
    @plan = Plan.new
    # 研修スケジュールを取得（研修情報も一緒に読み込み）
    @training_schedules = TrainingSchedule.includes(:training).order(:start_time)
  end

  # プラン作成処理
  def create
    @plan = Plan.new(plan_params)

    if @plan.save
      # --- 研修スケジュールの紐付け ---
      if params[:plan][:training_schedule_ids].present?
        # 空欄を除いて、選択されたスケジュールを取得
        schedules = TrainingSchedule.where(
          id: params[:plan][:training_schedule_ids].reject(&:blank?)
        )
        @plan.training_schedules = schedules
      end

      # --- 参加者の紐付け ---
      if params[:plan][:user_ids].present?
        user_ids = params[:plan][:user_ids].reject(&:blank?)
        # 選択されたユーザーを1人ずつPlanParticipationに登録
        user_ids.each do |uid|
          PlanParticipation.create!(plan: @plan, user_id: uid)
        end
      end

      redirect_to admin_plans_path, notice: "プランを作成しました"
    else
      # 保存できなかった場合はフォームを再表示
      @training_schedules = TrainingSchedule.includes(:training).order(:start_time)
      render :new, status: :unprocessable_entity
    end
  end

  # 一覧表示
  def index
    @plans = Plan.all
  end

  # 編集フォーム
  def edit
    # チェックボックスの状態を元に戻す
    @plan.selected_training_schedule_ids = @plan.training_schedule_ids
  end

  # 更新処理
  def update
    # 空欄を除いた選択済みスケジュールID
    @plan.selected_training_schedule_ids =
      params[:plan][:training_schedule_ids]&.reject(&:blank?) || []

    if @plan.update(plan_params)
      # 選択された研修スケジュールを更新
      @plan.training_schedules =
        TrainingSchedule.where(id: @plan.selected_training_schedule_ids)

      redirect_to admin_plans_path, notice: "プランを更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # 削除処理
  def destroy
    @plan.destroy
    redirect_to admin_plans_path, notice: "プランを削除しました"
  end

  private

  # 新規・編集フォーム用：今日以降の研修スケジュールを取得
  def load_training_schedules
    @training_schedules =
      TrainingSchedule
        .where('start_time >= ?', Time.zone.now.beginning_of_day) # 今日以降
        .order(start_time: :asc)
  end

  # 編集・削除用：対象プランを取得
  def set_plan
    @plan = Plan.find(params[:id]) # idで検索。見つからなければ例外
  end

  # 許可されたパラメータのみ受け取る（セキュリティ対策）
  def plan_params
    params.require(:plan).permit(:name, :description, training_schedule_ids: [], user_ids: [])
  end
end
