class RenameDateToStartTimeAndAddEndTimeToTrainingSchedules < ActiveRecord::Migration[8.1]
  def change
    rename_column :training_schedules, :date, :start_time
    add_column :training_schedules, :end_time, :datetime
  end
end
