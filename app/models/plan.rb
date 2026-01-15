# app/models/plan.rb
class Plan < ApplicationRecord
  # adminで使用　中間テーブルとの関連
  has_many :created_plans, dependent: :destroy
  has_many :training_schedules, through: :created_plans


  # uesrsで使用　中間テーブルとの関連
  has_many :plan_participations, dependent: :destroy
  has_many :users, through: :plan_participations

  #プラン名空白NG
  validates :name, presence: true

  # フォームで送られてくる研修スケジュールIDを一時保持
  attr_accessor :selected_training_schedule_ids

  # 保存前に期間・研修数を計算
  before_save :set_dates_and_count
end

  private

  # 研修初日と最終日を拾う → プラン期間・研修数計算に使用
  def set_dates_and_count
    return unless selected_training_schedule_ids.present?

    schedules = TrainingSchedule.where(id: selected_training_schedule_ids)

    # start_time / end_time を使用
    self.start_date = schedules.minimum(:start_time)&.to_date
    self.end_date   = schedules.maximum(:end_time)&.to_date || schedules.maximum(:start_time)&.to_date

    self.training_count = schedules.count
  end
