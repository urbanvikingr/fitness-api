class ExerciseDescriptionPolicy < ApplicationPolicy

  class Scope < Scope
    def resolve
      if user.administrator?
        scope.all
      elsif user.coach?
        scope.where(user_id: user.id)
      else
        raise Pundit::NotAuthorizedError, "You must log in."
      end
    end
  end

  def show?
    user.administrator? || (user.coach? && user.id == record.user_id)
  end

  def create?
    show?
  end

  def update?
    show?
  end

  def destroy?
    show?
  end
end
