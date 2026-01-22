class Training < ApplicationRecord
  has_many :training_schedules

  #PDF用 EC2のため容量制限
  has_many_attached :materials
  validates :materials,
    content_type: ['application/pdf'],
    size: { less_than: 20.megabytes, message: "は20MB以下にしてください" }

  #タイトル空白NF
  validates :title, :description, presence: true

  #削除前に表示
  before_destroy :prevent_destroy_if_has_schedules

  private

  # --------------------------------------------------
  # スケジュールが1件でも存在したら削除させない
  # --------------------------------------------------
  def prevent_destroy_if_has_schedules
    return if training_schedules.empty?

    messages = []

    # この研修に紐づくスケジュールを1件ずつ確認
    training_schedules.each do |schedule|
      # start_time があれば日付を表示、なければ未設定表示
      date =
        if schedule.start_time.present?
          schedule.start_time.strftime("%Y/%m/%d %H:%M")
        else
          "日時未設定"
        end

      messages << "・#{date}"
    end

    # --------------------------------------------------
    # エラーメッセージとしてまとめて追加
    # --------------------------------------------------
    errors.add(
      :base,
      "この研修は以下の日程のスケジュールで使用されているため削除できません。\n" +
      messages.join("\n")
    )

    # destroy を強制的に中断
    throw(:abort)
  end
end
