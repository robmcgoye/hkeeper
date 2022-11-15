class ApiKeysController < ApplicationController
  before_action :authenticate_user!
  before_action :set_account

  def update
    authorize @account
    if @account.update(private_api_key: SecureRandom.hex)
      redirect_to edit_account_path(@account), notice: "Account API was successfully generated."
    else
      redirect_to edit_account_path(@account), alert: "There was an error: #{@account.errors.full_messages.to_sentence}"
    end
  end
  
  private

  def set_account
    @account = Account.find(params[:id])
  end

end