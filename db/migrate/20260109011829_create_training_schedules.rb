# 日付、会場、講師セット後
class CreateTrainingSchedules < ActiveRecord::Migration[8.1]
  def change
    create_table :training_schedules do |t|
      t.references :training, null: false, foreign_key: true
      t.datetime :date
      t.references :room, null: false, foreign_key: true

      t.timestamps
    end
  end
end
