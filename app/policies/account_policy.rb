class AccountPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      if @user.has_any_role? :admin, :tech
        scope.all
      else
        scope.with_role(:manager, @user)
      end
    end
  end

  def show?
    @user.has_any_role? :admin, :tech, { name: :manager, resource: @record }
  end
  
  def new?
    create?
  end

  def create?
    @user.has_role? :admin  
  end

  def edit?
    update?
  end

  def update?
    @user.has_any_role? :admin, :tech #, { name: :creator, resource: @record }
  end

  def destroy?
    @user.has_role? :admin
  end 

end
