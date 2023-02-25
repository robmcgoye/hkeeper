class UnifiSitesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_accounts, except: %i[ index destroy show ]
  before_action :set_unifi_site, only: %i[ show edit update destroy ]

  def index
    @pagy, @unifi_sites = pagy(policy_scope(UnifiSite))
    # @unifi_sites = policy_scope(UnifiSite)
  end

  def new
    @unifi_site = UnifiSite.new
    authorize @unifi_site
  end

  def show
  end

  def edit
  end

  def create
    @unifi_site = UnifiSite.new(unifi_site_params)
    if @unifi_site.save
      redirect_to unifi_site_url(@unifi_site), notice: "Unifi site was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @unifi_site.update(unifi_site_params)
      redirect_to unifi_site_url(@unifi_site), notice: "Unifi site  was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @unifi_site.destroy
    redirect_to unifi_site_url, notice: "Unifi site was successfully destroyed."
  end

  private

    def set_accounts
      @accounts = policy_scope(Account)
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_unifi_site
      @unifi_site = UnifiSite.find(params[:id])
      authorize @unifi_site
    end

    # Only allow a list of trusted parameters through.
    def unifi_site_params
      params.require(:unifi_site).permit(:account_id, :name, :notes, :hosting_fee)
    end
end