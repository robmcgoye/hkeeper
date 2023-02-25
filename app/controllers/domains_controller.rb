class DomainsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_accounts, except: %i[ index destroy show ]
  before_action :set_domain, only: %i[ show edit update destroy ]

  def index
    @pagy, @domains = pagy(policy_scope(Domain))
  end

  def show
  end

  def new
    @domain = Domain.new
    authorize @domain
  end

  def edit
  end

  def create
    @domain = Domain.new(domain_params)
    respond_to do |format|
      if @domain.save
        format.html { redirect_to domain_url(@domain), notice: "Domain was successfully created." }
        format.json { render :show, status: :created, location: @domain }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @domain.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @domain.update(domain_params)
        format.html { redirect_to domain_url(@domain), notice: "Domain was successfully updated." }
        format.json { render :show, status: :ok, location: @domain }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @domain.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @domain.destroy

    respond_to do |format|
      format.html { redirect_to domains_url, notice: "Domain was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

    def set_accounts
      @accounts = policy_scope(Account)
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_domain
      @domain = Domain.find(params[:id])
      authorize @domain
    end

    # Only allow a list of trusted parameters through.
    def domain_params
      params.require(:domain).permit(:account_id, :name, :expires_on, :notes, :web_hosting, :email_hosting,
         :registration, :registration_fee, :hosting_fee)
    end
end
