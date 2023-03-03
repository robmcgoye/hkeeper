class StatementPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      if @user.has_any_role? :admin, :tech
        scope.all
      else
        unifi_ids = Statement.where(service_id: UnifiSite.where(account_id: (Account.with_role(:manager, @user).pluck(:id))).pluck(:id)).where(service_type: "UnifiSite").pluck(:id)
        domain_ids = Statement.where(service_id: Domain.where(account_id: (Account.with_role(:manager, @user).pluck(:id))).pluck(:id)).where(service_type: "Domain").pluck(:id)
          
        scope.where(id: (domain_ids + unifi_ids))
      end
    end
  end

  def edit?
    @user.has_any_role? :admin, :tech
  end

  def show?
    authorized_roles?
  end

  def update?
    authorized_roles?
  end

  def pdf?
    authorized_roles?
  end

  private

  def authorized_roles?
    @user.has_any_role? :admin, :tech, { name: :manager, resource: @record.service.account }
  end

end