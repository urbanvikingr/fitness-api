class TransactionPolicy < ApplicationPolicy

  class Scope < Scope
    def resolve
      if user.administrator?
        scope.all
      elsif user.coach?
        scope.where(merchant_id: user.id)
      elsif user.id?
        scope.where(user_id: user.id)
      else
        raise Pundit::NotAuthorizedError, "You must log in."
      end
    end
  end

  def show?
    user.administrator? || user.id == record.user_id
  end

  def new?
    user.id?
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
