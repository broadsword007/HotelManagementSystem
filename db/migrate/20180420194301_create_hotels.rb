class CreateHotels < ActiveRecord::Migration[5.0]
  def change
    create_table :hotels do |t|
      t.string :name
      t.string :slogan
      t.string :location
      t.string :hotel_pic_path
      t.string :description

      t.timestamps
    end
  end
end
