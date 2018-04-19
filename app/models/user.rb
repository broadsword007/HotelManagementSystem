class User < ApplicationRecord
  # Include default users modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  belongs_to :role
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  # has_attached_file :profile_pic,
  #                   :storage => :cloudinary,
  #                   :cloudinary_credentials => Rails.root.join("config/cloudinary.yml"),
  #                   :cloudinary_resource_type => :image
end
