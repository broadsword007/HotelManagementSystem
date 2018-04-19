class AddProfileInfoToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :profile_pic_path, :string
    add_column :users, :firstname, :string
    add_column :users, :lastname, :string
    add_column :users, :dob, :date
  end
end
