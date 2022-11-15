class UserRolesController < ApplicationController
  before_action :authenticate_user!
  
  def index
    authorize :user_role, :index?
    @users = User.all
  end
  
end
