class SessionsController < ApplicationController
  before_action :redirect_if_authenticated, only: [:create, :new]

  def create
    @user = User.find_by(email: params[:user][:email].downcase)
    if @user
      if @user.unconfirmed?
        redirect_to new_confirmation_path, alert: "Account not confirmed."
      elsif @user.authenticate(params[:user][:password])
        if @user.active?
          login @user
          redirect_to root_path, notice: "Signed in."
        else
          failed_login("Account has been disabled. Contact the administrator.") 
        end
      else
        failed_login("Incorrect email or password.")
      end
    else
      failed_login("Incorrect email or password.")
    end
  end

  def destroy
    logout
    redirect_to root_path, notice: "Signed out."
  end

  def new
  end

  private

  def failed_login(message)
    flash.now[:alert] = message
    render :new, status: :unprocessable_entity
  end
end