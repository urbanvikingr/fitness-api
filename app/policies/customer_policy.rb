class CustomerPolicy < ApplicationPolicy

  class Scope < Scope
    def resolve
      if user.administrator?
        scope.all
      elsif user.coach?
        scope.all
      else
        raise Pundit::NotAuthorizedError, "You must log in."
      end
    end
  end

  def show?
    user.administrator? || user.id == record.user_id
  end

  def create?
    show?
  end

  def update?
    user.administrator?
  end

  def destroy?
    update?
  end
end