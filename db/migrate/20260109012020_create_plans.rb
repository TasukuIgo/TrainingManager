# training_schedulesをグループ化し参加者を保存
class CreatePlans < ActiveRecord::Migration[8.1]
  def change
    create_table :plans do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
