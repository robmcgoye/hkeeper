class DomainsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_accounts, except: %i[ index destroy show ]
  before_action :set_domain, only: %i[ show edit update destroy ]

  def filter
    set_filter(:domain_filter, {"account_id" => params[:domain_filter_form][:account_id]})
    @domain_form = DomainFilterForm.new(domain_filter_params)
    @sort = "account"
    @pagy, @domains = pagy(@domain_form.filter(policy_scope(Domain), @sort))
    render :index 
  end 

  def sort
    @domain_form = get_filter_form
    @sort = params[:sort]
    @pagy, @domains = pagy(@domain_form.filter(policy_scope(Domain), @sort))
    render turbo_stream: [
      turbo_stream.replace("filter_results", partial: "domains/filter_results")
    ]
  end

  def index
    @domain_form = get_filter_form
    @sort = "account"
    @pagy, @domains = pagy(@domain_form.filter(policy_scope(Domain), @sort))
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
    if @domain.save
      flash.now[:notice] = "Domain was successfully created."
      @sort = "account"
      @domain_form = get_filter_form
      @pagy, @domains = pagy(@domain_form.filter(policy_scope(Domain), @sort))
      render turbo_stream: [
        turbo_stream.replace("filter_results", partial: "domains/filter_results"), 
        # locals: {domains: @domains, pagy: @pagy}
        turbo_stream.update(Domain.new, partial: "domains/index_new"), 
        turbo_stream.replace("notice", partial: "layouts/flash")
      ]
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update

    if @domain.update(domain_params)
        flash.now[:notice] = "Domain was successfully updated."

        render turbo_stream: [
          turbo_stream.replace(@domain, partial: "domains/domain", locals: { domain: @domain, page: params[:domain][:page].to_i, index: params[:domain][:index].to_i }
          ), 
          turbo_stream.replace("notice", partial: "layouts/flash")
        ]
        # format.html { redirect_to domain_url(@domain), notice: "Domain was successfully updated." }
        # format.json { render :show, status: :ok, location: @domain }
        # format.turbo_stream
      else
        render :edit, status: :unprocessable_entity
      end
  end

  def destroy
    @domain.destroy
    flash.now[:notice] = "Domain was successfully deleted."
    @sort = "account"
    @domain_form = get_filter_form
    @pagy, @domains = pagy(@domain_form.filter(policy_scope(Domain), @sort))
    render turbo_stream: [
      # turbo_stream.remove(@domain),
      turbo_stream.replace("filter_results", partial: "domains/filter_results"),
      turbo_stream.replace("notice", partial: "layouts/flash")
      # locals: {domains: @domains, pagy: @pagy}
    ]
  end

  private

    def get_filter_form
      domain_filter = get_filter(:domain_filter)
      if domain_filter.nil?
        DomainFilterForm.new
      else
        DomainFilterForm.new(domain_filter)
      end
    end

    def select_domains(domain_form)
      @pagy, @domains = pagy(domain_form.filter(policy_scope(Domain))) 
    end

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

    def domain_filter_params
      params.require(:domain_filter_form).permit(:account_id)
    end
end
