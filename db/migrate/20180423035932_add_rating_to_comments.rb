class AddRatingToComments < ActiveRecord::Migration[5.0]
  def change
    add_column :comments, :rating, :float
  end
end
