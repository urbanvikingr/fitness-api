class CoachPolicy < ApplicationPolicy

  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def create?
    if user.present?
      user.administrator?
    end
  end

  def update?
    create?
  end

  def destroy?
    create?
  end
end
