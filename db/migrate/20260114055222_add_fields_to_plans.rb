class AddFieldsToPlans < ActiveRecord::Migration[8.1]
  def change
    add_column :plans, :participants, :string
    add_column :plans, :start_date, :date
    add_column :plans, :end_date, :date
    add_column :plans, :training_count, :integer
  end
end
