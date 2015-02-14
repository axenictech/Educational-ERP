class Ability
  include CanCan::Ability

  def initialize(user)
    if user.role == 'SuperAdmin'
      can :manage, :all
    elsif user.role == 'Admin'
      can [:read, :create, :update], :all
    elsif user.role == 'Employee'
      can :read, [TimeTable, Employee, ArchivedEmployee]
      can [:read, :create, :update], [ExamGroup, Exam, ExamScore]
    else
      can [:read, :update], [Student, ArchivedStudent]
      can :read, TimeTable
    end
  end
end
