class RenameUserProfilePicPathToUserProfilePic < ActiveRecord::Migration[5.0]
  def change
    rename_column :users, :profile_pic_path, :profile_pic
  end
end
