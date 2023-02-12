class JobPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end

  def new?
    create?
  end

  def create?
     # Need to test for account managers too!
    @user.has_any_role? :admin, :tech
  end

  def edit?
    update?
  end

  def update?
    @user.has_any_role? :admin, :tech
  end

  def destroy?
    @user.has_any_role? :admin, :tech
  end

  def show?
    @user.has_any_role? :admin, :tech, { name: :manager, resource: @record.computer.account }
  end
end
