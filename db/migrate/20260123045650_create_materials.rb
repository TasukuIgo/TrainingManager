class CreateMaterials < ActiveRecord::Migration[8.1]
  def change
    create_table :materials do |t|
      t.references :training, null: false, foreign_key: true
      t.string :file_path, null: false
      t.string :original_filename, null: false
      t.string :content_type
      t.timestamps
    end
  end
end
