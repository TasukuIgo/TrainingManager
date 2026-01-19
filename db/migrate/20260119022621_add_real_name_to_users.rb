class AddRealNameToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :real_name, :string
  end
end
