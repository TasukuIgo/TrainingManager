# app/models/plan.rb
class Plan < ApplicationRecord
  # 中間テーブルとの関連
  has_many :created_plans, dependent: :destroy
  has_many :training_schedules, through: :created_plans

  # フォームで送られてくる研修スケジュールIDを一時保持
  attr_accessor :selected_training_schedule_ids

  # 保存前に期間・研修数を計算
  before_save :set_dates_and_count

  private

  #研修初日と最終日を拾う→プラン期間の計算に使用
  def set_dates_and_count
    return unless selected_training_schedule_ids.present?

    schedules = TrainingSchedule.where(id: selected_training_schedule_ids)
    self.start_date = schedules.minimum(:date)
    self.end_date   = schedules.maximum(:date)
    self.training_count = schedules.count
  end
end
