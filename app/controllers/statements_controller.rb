class StatementsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_statement, only: %i[ show pdf edit update ]

  def filter
    set_filter(:statement_filter, build_filter_params)
    @statement_form = StatementFilterForm.new(statement_filter_params)
    @pagy, @statements = pagy(@statement_form.filter(policy_scope(Statement)))
    render :index
  end

  def index
    statement_filter = get_filter(:statement_filter)
    if statement_filter.nil?
      @statement_form = StatementFilterForm.new
      @pagy, @statements = pagy(policy_scope(Statement).unpaid)
    else
      @statement_form = StatementFilterForm.new(statement_filter)
      @pagy, @statements = pagy(@statement_form.filter(policy_scope(Statement)))
    end
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

  def get_filter_param(filter_param)
    if filter_param.nil?
      0
    else
      filter_param
    end
  end

  def build_filter_params
    {
      "pending" => get_filter_param(params[:statement_filter_form][:pending]),
      "unpaid" => get_filter_param(params[:statement_filter_form][:unpaid]),
      "paid" => get_filter_param(params[:statement_filter_form][:paid]),
      "voided" => get_filter_param(params[:statement_filter_form][:voided]),
      "account_id" => get_filter_param(params[:statement_filter_form][:account_id])
    }
  end
end