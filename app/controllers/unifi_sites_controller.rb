class UnifiSitesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_accounts, except: %i[ index destroy show ]
  before_action :set_unifi_site, only: %i[ show edit update destroy ]

  def filter
    set_filter(:unifi_site_filter, {"account_id" => params[:unifi_site_filter_form][:account_id]})
    @unifi_site_form = UnifiSiteFilterForm.new(unifi_site_filter_params)
    @pagy, @unifi_sites = pagy(@unifi_site_form.filter(policy_scope(UnifiSite)))
    render :index  
  end 

  def index
    @unifi_site_form = get_filter_form
    @pagy, @unifi_sites = pagy(@unifi_site_form.filter(policy_scope(UnifiSite)))
  end

  def new
    @unifi_site = UnifiSite.new
    authorize @unifi_site
  end

  def show
    @page = params[:page]
  end

  def edit
  end

  def create
    @unifi_site = UnifiSite.new(unifi_site_params)
    if @unifi_site.save
      flash.now[:notice] = "Unifi site was successfully created."
      @unifi_site_form = get_filter_form
      @pagy, @unifi_sites = pagy(@unifi_site_form.filter(policy_scope(UnifiSite)))
      render turbo_stream: [
        turbo_stream.replace("filter_results", partial: "unifi_sites/filter_results"), 
        # locals: {domains: @domains, pagy: @pagy}
        turbo_stream.update(UnifiSite.new, partial: "unifi_sites/index_new"), 
        turbo_stream.replace("notice", partial: "layouts/flash")
      ]
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @unifi_site.update(unifi_site_params)
      # redirect_to unifi_site_url(@unifi_site), notice: "Unifi site  was successfully updated."
      flash.now[:notice] = "Unifi site was successfully updated."
      render turbo_stream: [
        turbo_stream.replace(@unifi_site, partial: "unifi_sites/unifi_site", locals: { unifi_site: @unifi_site, page: params[:unifi_site][:page].to_i, index: params[:unifi_site][:index].to_i }
        ), 
        turbo_stream.replace("notice", partial: "layouts/flash")
      ]
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @unifi_site.destroy
    # redirect_to unifi_site_url, notice: "Unifi site was successfully destroyed."
    flash.now[:notice] = "Unifi site was successfully deleted."
    @unifi_site_form = get_filter_form
    @pagy, @unifi_sites = pagy(@unifi_site_form.filter(policy_scope(UnifiSite)))
    render turbo_stream: [
      turbo_stream.replace("filter_results", partial: "unifi_sites/filter_results"),
      turbo_stream.replace("notice", partial: "layouts/flash")
    ]
  end

  private

    def get_filter_form
      unifi_site_filter = get_filter(:unifi_site_filter)
      if unifi_site_filter.nil?
        UnifiSiteFilterForm.new
      else
        UnifiSiteFilterForm.new(unifi_site_filter)
      end
    end

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

    def unifi_site_filter_params
      params.require(:unifi_site_filter_form).permit(:account_id)
    end    
end