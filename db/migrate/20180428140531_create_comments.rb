class CreateComments < ActiveRecord::Migration[5.0]
  def change
    create_table :comments do |t|
      t.string :title
      t.string :content
      t.references :user, foreign_key: true
      t.integer :rating

      t.timestamps
    end
  end
end
