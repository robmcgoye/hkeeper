class AccountRolePolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end

  def index?
    @user.has_any_role? :admin, :tech
  end

  def destroy?
    authorized_roles?
  end

  def create?
    authorized_roles?
  end

  def new?
    create?
  end

  private

  def authorized_roles?
    @user.has_any_role? :admin
  end

end
