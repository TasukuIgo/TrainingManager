class AddExternalUserIdToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :external_user_id, :bigint #null: false(既存テストデータがあるため一旦コメントアウト)
    add_index  :users, :external_user_id, unique: true
  end
end