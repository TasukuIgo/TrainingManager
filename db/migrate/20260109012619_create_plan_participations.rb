# plan参加者
class CreatePlanParticipations < ActiveRecord::Migration[8.1]
  def change
    create_table :plan_participations do |t|
      t.references :plan, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
