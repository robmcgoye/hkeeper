class AccountRolesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_account
  before_action :set_user, only: [:destroy, :create]
  
  def create
    authorize :account_role, :create?
    if !@user.has_any_role? :creator, :manager
      @user.add_role :manager, @account
      redirect_to account_roles_path, notice: "User was successfully added."
    else
      redirect_to account_roles_path, notice: "User already a manager."
    end
  end

  def index
    authorize :account_role, :index?
  end
 
  def new
    authorize :account_role, :new?
  end

  def destroy
    authorize :account_role, :destroy?
    if !@user.has_role? :creator, @account
      if @user.has_role? :manager, @account
        @user.remove_role :manager, @account
        redirect_to account_roles_path, notice: "Successfully removed role. #{@user.email}"
      else
        redirect_to account_roles_path, alert: "User doesn't have this role."        
      end
    else
      redirect_to account_roles_path, alert: "Can't remove the owner from this account."
    end
  end

  private

    def set_account
      @account = Account.find_by id: params[:account_id]
    end
  
    def set_user
      @user = User.find_by id: params[:user_id]
    end
end
