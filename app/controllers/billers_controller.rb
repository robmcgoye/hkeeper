class BillersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_account
  before_action :set_biller, only: %i[ edit update ]

  def create
    @biller = @account.billers.new(biller_params)
    authorize @biller
    if @biller.save
      redirect_to accounts_path, notice: "Settings were successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def new
    @biller = @account.billers.new
    authorize @biller
  end 

  def edit
  end 

  def update
    if @biller.update(biller_params)
      redirect_to accounts_path, notice: "Settings were successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end
  
  private

  def set_biller
    @biller = @account.billers.first
    authorize @biller    
  end 

  def set_account
    @account = Account.find(params[:account_id])
  end

  def biller_params
    params.require(:biller).permit(:account_id, :address_line_1, :address_line_2, :city, :state, :zip,
       :user_id)
  end
end