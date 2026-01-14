class CreateTrainingParticipations < ActiveRecord::Migration[8.1]
  def change
    create_table :training_participations do |t|
      t.references :user, null: false, foreign_key: true
      t.references :training_schedule, null: false, foreign_key: true
      t.string :status

      t.timestamps
    end
  end
end
