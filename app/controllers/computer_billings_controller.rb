class ComputerBillingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_account
  before_action :set_computer_billing, only: %i[ edit update ]

  def create
    @computer_billing = @account.create_computer_billing(computer_billing_params)
    authorize @computer_billing
    if @computer_billing.save
      redirect_to accounts_path, notice: "Settings were successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def new
    @computer_billing = ComputerBilling.new
    authorize @computer_billing
  end 

  def edit
  end 

  def update
    if @computer_billing.update(computer_billing_params)
      redirect_to accounts_path, notice: "Settings were successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end
  
  private

  def set_computer_billing
    @computer_billing = @account.computer_billing
    authorize @computer_billing    
  end 

  def set_account
    @account = Account.find(params[:account_id])
  end

  def computer_billing_params
    params.require(:computer_billing).permit(:account_id, :cost_per_job)
  end  
end