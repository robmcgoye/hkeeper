class DomainPolicy < ApplicationPolicy
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
  
  def new?
    create?
  end

  def show?
    @user.has_any_role? :admin, :tech, { name: :manager, resource: @record.account }
  end

  def create?
    @user.has_role? :admin  
  end

  def edit?
    update?
  end

  def update?
    @user.has_any_role? :admin, :tech
  end

  def destroy?
    @user.has_any_role? :admin
  end 

end
