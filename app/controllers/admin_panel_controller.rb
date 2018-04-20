class AdminPanelController < ApplicationController
  def index
    if(user_signed_in?)
      if(current_user.role.id==0)
        @users=User.all
        @hotels=Hotel.all
        render :template => "admin_panel/index"
      else
        redirect_to root_path
      end
    else
      redirect_to new_user_session_path
    end
  end
end
