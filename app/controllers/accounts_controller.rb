class AccountsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_account, only: %i[ edit update destroy ]

  def index
    @accounts = policy_scope(Account)
  end

  def new
    @account = Account.new
    authorize @account
  end

  def edit
  end

  def create
    @account = Account.new(account_params)
    authorize @account
    respond_to do |format|
      if @account.save
        current_user.add_role :creator, @account
        current_user.add_role :manager, @account
        format.html { redirect_to accounts_path, notice: "Account was successfully created." }
        format.json { render :show, status: :created, location: @account }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @account.update(account_params)
        format.html { redirect_to accounts_path, notice: "Account was successfully updated." }
        format.json { render :show, status: :ok, location: @account }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /accounts/1 or /accounts/1.json
  def destroy
    @account.destroy
    respond_to do |format|
      format.html { redirect_to accounts_path, notice: "Account was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_account
      @account = Account.find(params[:id])
      authorize @account
    end

    # Only allow a list of trusted parameters through.
    def account_params
      params.require(:account).permit(:name)
    end

end
