# frozen_string_literal: true
require 'securerandom'
class Users::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  def create

    rand_hex = SecureRandom.hex(10)
    pimage = params[:user][:profile_pic]
    if(pimage==nil)
      flash[:notice]= "Please attach your profile picture"
      redirect_to new_user_registration_path
      return
    end
    puts pimage.original_filename
    @uploadedFile=pimage
    cl_response = Cloudinary::Uploader.upload(@uploadedFile.tempfile, :public_id => rand_hex)
    if(cl_response['secure_url']==nil)
      flash[:notice]= "There is a server side problem. Please try again later"
      redirect_to new_user_registration_path
      return
    end
    params[:user][:profile_pic]=cl_response['secure_url']
    if(User.all.count==0)
      params[:user][:role_id]= Role.find(0).id; # make first user the admin
    else
      params[:user][:role_id]= Role.find(1).id;
    end
    puts "\n\n\n"
    puts params.inspect
    # params=filterParams
    # puts params.inspect
    #
    # puts params[:profile_pic].tempfile
    configure_sign_up_params
    super
  end

  # GET /resource/edit
  def edit
    if(!user_signed_in?)
      redirect_to new_user_session_path, root_path
    elsif(current_user.role.id!=0 && current_user.id!=params[:format])
       redirect_to root_path
    end
    @user = User.find_by_id(params[:format])
    puts @user.inspect
  end

  # PUT /resource
  def update
    params[:user][:profile_pic]=current_user.profile_pic
    params[:user][:role_id]= current_user.role_id;
    puts "\n\n\n"
    puts params.inspect
    # params=filterParams
    # puts params.inspect
    #
    # puts params[:profile_pic].tempfile
    configure_account_update_params
    super
  end

  # DELETE /resource
  def destroy
    if(!user_signed_in?)
      redirect_to new_user_session_path, root_path
    elsif(current_user.role.id!=0 && current_user.id!=params[:format])
      redirect_to root_path
    end
    @user = User.find_by_id(params[:format])
    if @user.destroy
      puts "\n\n\n\n #{"User deleted successffully with id #{params[:format]}"} \n\n\n\n"
      redirect_to adminpanel_path
    else
      puts "\n\n\n\n #{"Unable to delete user with id #{params[:format]}"} \n\n\n\n"
      redirect_to adminpanel_path
    end
  end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  #If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:profile_pic, :firstname, :lastname, :dob, :role_id])
    #params.require(:user).permit(:profile_pic, :firstname, :lastname, :dob, :role_id, :email, :password, :password_confirmation)
  end

  #If you have extra params to permit, append them to the sanitizer.
  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:profile_pic, :firstname, :lastname, :dob, :role_id])
    #params.require(:user).permit(:profile_pic, :firstname, :lastname, :dob, :role_id, :email, :password, :password_confirmation)
  end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
  def update_picture
    puts "\n\nUpdating picture"
    puts params.inspect
    puts "\n\n\n"
    if(current_user==nil)
      redirect_to edit_user_registration_path
      return
    end
    rand_hex = SecureRandom.hex(10)
    pimage = params[:profile_pic]
    if(pimage!=nil)
      puts pimage.original_filename
      @uploadedFile=pimage
      cl_response = Cloudinary::Uploader.upload(@uploadedFile.tempfile, :public_id => rand_hex)
      if(cl_response['secure_url']==nil)
        flash[:notice]= "There is a server side problem. Please try again later"
        redirect_to edit_user_registration_path
        return
      end
      current_user.update(profile_pic: cl_response['secure_url'])
      redirect_to edit_user_registration_path(current_user)
    else
      redirect_to edit_user_registration_path(current_user)
      return
    end
  end
  private
  def filterParams
    #puts params.inspect
    #params.require(:user).permit(:profile_pic, :firstname, :lastname, :email, :dob, :password,
                                 #:password_confirmation)
  end
end
