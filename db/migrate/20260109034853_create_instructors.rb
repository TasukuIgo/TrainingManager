class CreateInstructors < ActiveRecord::Migration[8.1]
  def change
    create_table :instructors do |t|
      t.references :user, null: false, foreign_key: true
      t.references :training_schedule, null: false, foreign_key: true

      t.timestamps
    end
  end
end
