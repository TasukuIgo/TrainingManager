class CreateCreatedPlans < ActiveRecord::Migration[8.1]
  def change
    create_table :created_plans do |t|
      t.references :plan, null: false, foreign_key: true
      t.references :training_schedule, null: false, foreign_key: true

      t.timestamps
    end
  end
end
