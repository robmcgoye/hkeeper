class StatementsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_statement, only: %i[ show ]

  def index
    @statements = policy_scope(Statement)
  end

  def show
    @biller = @statement.account.billers.first
    respond_to do |format|
      format.html
      # format.pdf do
      #   render pdf: "show"   # Excluding ".pdf" extension.
      # end
    end
  end

  private

  def set_statement
    @statement = Statement.find(params[:id])
    authorize @statement
  end

end