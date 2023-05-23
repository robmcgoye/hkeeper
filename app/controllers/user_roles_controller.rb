class UserRolesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_permissions
  before_action :set_user, only: %i[ edit update ]

  def edit
    @user_roles = UserRole.new({"admin" => (@user.has_role? :admin), "tech" => (@user.has_role? :tech), "user" => (@user.has_role? :user)})
  end

  def update
    if current_user != @user
      if UserRole.new(role_params).update(@user)
        redirect_to user_administration_index_path, notice: "Updated roles for #{@user.full_name}."
      else
        redirect_to user_administration_index_path, alert: "Must have at least one role assigned for user: #{@user.full_name}. Added the user role!"
      end
    else
      redirect_to user_administration_index_path, alert: "Can't modify roles for the logged in user."
    end
  end

  private
  
  def check_permissions
    authorize :user_administration, :cru_actions?
  end

  def role_params
    params.require(:user_role).permit(:admin, :tech, :user)
  end

  def set_user
    @user = User.find(params[:user_administration_id])
  end

end
