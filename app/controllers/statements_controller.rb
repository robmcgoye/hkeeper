class StatementsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_statement, only: %i[ show pdf edit update ]

  def filter
    @statement_form = StatementFilterForm.new(statement_filter_params)
    query = Statement.empty
    if params[:statement_filter_form][:pending].to_i == 1 
      query += (policy_scope(Statement).pending).pluck(:id)
    end      
    if params[:statement_filter_form][:unpaid].to_i == 1
      query += (policy_scope(Statement).unpaid).pluck(:id)
    end
    if params[:statement_filter_form][:paid].to_i == 1
      query += (policy_scope(Statement).paid).pluck(:id)
    end        
    if params[:statement_filter_form][:voided].to_i == 1
      query += (policy_scope(Statement).voided).pluck(:id)
    end
    if params[:statement_filter_form][:account_id].to_i > 0
      @pagy, @statements = pagy((Statement.where(id: query)).statements_in_account(params[:statement_filter_form][:account_id].to_i).order(invoiced_at: :desc))
    else
      @pagy, @statements = pagy(Statement.where(id: query).order(invoiced_at: :desc))  
    end
  end

  def index
    @statement_form = StatementFilterForm.new
    @pagy, @statements = pagy(policy_scope(Statement).unpaid)
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
    @biller = @statement.service.account.billers.first
  end

  def statement_params
    params.require(:statement).permit(:status, :terms, :invoiced_at)
  end

  def statement_filter_params
    params.require(:statement_filter_form).permit(:paid, :unpaid, :pending, :voided, :account_id)
  end
end