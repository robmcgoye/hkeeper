class DashboardsController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @accounts = policy_scope(Account)
  end
  
end