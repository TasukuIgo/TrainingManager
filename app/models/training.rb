class Training < ApplicationRecord
  has_many :training_schedules
  has_many :materials, dependent: :destroy

  # タイトル・説明は必須
  validates :title, :description, presence: true

  # 削除前にスケジュール存在チェック
  before_destroy :prevent_destroy_if_has_schedules

  private

  def prevent_destroy_if_has_schedules
    return if training_schedules.empty?

    messages = []

    training_schedules.each do |schedule|
      date =
        if schedule.start_time.present?
          schedule.start_time.strftime("%Y/%m/%d %H:%M")
        else
          "日時未設定"
        end

      messages << "・#{date}"
    end

    errors.add(
      :base,
      "この研修は以下の日程のスケジュールで使用されているため削除できません。\n" +
      messages.join("\n")
    )

    throw(:abort)
  end
end
