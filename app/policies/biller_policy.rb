class BillerPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!

  end
  
  def new?
    create?
  end

  def create?
    @user.has_role? :admin, :tech
  end

  def edit?
    update?
  end

  def update?
    @user.has_any_role? :admin, :tech
  end

end
