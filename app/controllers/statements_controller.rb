class StatementsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_statement, only: %i[ show pdf edit update ]

  def index
    @statements = policy_scope(Statement)
  end

  def show
  end

  def edit
  end

  def update
    if @statement.update(statement_params)
      redirect_to statement_url(@statement), notice: "Status was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def pdf
    respond_to do |format|
      format.pdf do
        # https://github.com/mileszs/wicked_pdf/issues/1005
        render pdf: "invoice: #{@statement.invoice_number}", # filename
               template: "statements/pdf",
               formats: [:html],
               disposition: :inline,
               layout: 'pdf'
      end
    end
  end

  private

  def set_statement
    @statement = Statement.find(params[:id])
    authorize @statement
    @biller = @statement.account.billers.first
  end

  def statement_params
    params.require(:statement).permit(:status, :terms, :invoiced_at)
  end
end