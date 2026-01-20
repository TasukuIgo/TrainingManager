class Plan < ApplicationRecord
  # adminで使用　中間テーブルとの関連
  has_many :created_plans, dependent: :destroy
  has_many :training_schedules, through: :created_plans


  # uesrsで使用　中間テーブルとの関連
  has_many :plan_participations, dependent: :destroy
  has_many :users, through: :plan_participations

  # adminで使用　中間テーブルとの関連
  has_many :participants, through: :plan_participations, source: :user

  #プラン名空白NG
  validates :name, presence: true
  validates :users, presence: { message: "を1人以上選択してください" }

  # フォームで送られてくる研修スケジュールIDを一時保持
  attr_accessor :selected_training_schedule_ids

  # 保存前に期間・研修数を計算
  before_save :set_dates_and_count

  def start_date
      training_schedules.minimum(:start_time)&.to_date
    end

   def end_date
    training_schedules.maximum(:start_time)&.to_date
  end

  def training_days
    return nil if start_date.blank? || end_date.blank?

    (end_date - start_date).to_i + 1
  end
end