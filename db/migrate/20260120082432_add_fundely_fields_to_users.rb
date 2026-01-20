class AddFundelyFieldsToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :fundely_user_id, :integer
  end
end
