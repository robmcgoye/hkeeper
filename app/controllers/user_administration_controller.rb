class UserAdministrationController < ApplicationController
  before_action :authenticate_user!
  before_action :check_permissions
  before_action :set_user, only: %i[ show edit update create ]

  def index
    @users = User.all
  end
  
  def show
  end

  def edit
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to user_administration_url(@user), notice: "User was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @user.update(user_params)
      redirect_to user_administration_url(@user), notice: "User  was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:active, :email, :password, :password_confirmation, :first_name, :last_name, :phone, :confirmed_email)
  end

  def check_permissions
    authorize :user_administration, :cru_actions?
  end

  def set_user
    @user = User.find(params[:id])
  end

end
