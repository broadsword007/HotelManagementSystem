class CreateBookings < ActiveRecord::Migration[5.0]
  def change
    create_table :bookings do |t|
      t.references :user, foreign_key: true
      t.references :room, foreign_key: true
      t.date :from
      t.date :to
      t.boolean :hasCheckedOut

      t.timestamps
    end
  end
end
