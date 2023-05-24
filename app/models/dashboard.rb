class Dashboard

  def initialize(user)
    @user = user
    if @user.has_any_role? :admin, :tech
      @user_accounts = Account.all.pluck(:id)
    else
      @user_accounts = Account.with_role(:manager, @user).pluck(:id)
    end
    @computers = Computer.computers_in_account(@user_accounts)
    @domains = Domain.domains_in_account(@user_accounts)
    @unifi_sites = UnifiSite.unifi_sites_in_account(@user_accounts)
  end

  def computer_count
    @computers.size
  end

  def account_count
    @user_accounts.size
  end

  def domain_count
    @domains.size
  end

  def unifi_site_count
    @unifi_sites.size
  end

  def computers_not_contacted(number_of_days)
    @computers.not_contacted(number_of_days)
  end

  def computers_with_errors
    @computers.job_errors
  end

end