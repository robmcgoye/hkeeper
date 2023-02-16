class StatementsController < ApplicationController
  before_action :authenticate_user!

  def index
    @statements = policy_scope(Statement)
  end

  private

  def set_account
    @statement = Statement.find(params[:id])
    authorize @statement
  end

end