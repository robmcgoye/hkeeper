class ComputerPolicy < ApplicationPolicy
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
  
  def edit?
    @user.has_any_role? :admin, :tech
  end

  def update?
    edit?
  end
  
  def show?
    @user.has_any_role? :admin, :tech, { name: :manager, resource: @record.account }
  end
  
  def destroy?
    @user.has_any_role? :admin
  end

end