class CreateRooms < ActiveRecord::Migration[5.0]
  def change
    create_table :rooms do |t|
      t.string :number
      t.boolean :isAvailable
      t.string :description
      t.references :hotel, foreign_key: true

      t.timestamps
    end
  end
end
