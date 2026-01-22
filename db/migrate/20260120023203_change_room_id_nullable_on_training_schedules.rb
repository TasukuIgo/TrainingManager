class ChangeRoomIdNullableOnTrainingSchedules < ActiveRecord::Migration[8.1]
  def change
     change_column_null :training_schedules, :room_id, true
  end
end
