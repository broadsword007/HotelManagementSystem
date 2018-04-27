class CreateRoomCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :room_categories do |t|
      t.string :name
      t.string :description
      t.integer :rate
      t.string :category_pic_path

      t.timestamps
    end
  end
end
