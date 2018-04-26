class CreateRooms < ActiveRecord::Migration[5.0]
  def change
    create_table :rooms do |t|
      t.string :number
      t.boolean :isAvailable
      t.string :description
      t.references :room_category, foreign_key: true
      t.string :price
      t.references :user, foreign_key: true
      t.float :rating
      t.string :room_pic_path
      t.timestamps
    end
  end
end