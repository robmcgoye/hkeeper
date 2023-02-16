class StatementPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      if @user.has_any_role? :admin, :tech
        scope.all
      else
        scope.where(account_id: (Account.with_role(:manager, @user).pluck(:id)))
      end
    end
  end

  def show?
  end

  private

  def authorized_roles?
    @user.has_any_role? :admin, :tech
  end

end