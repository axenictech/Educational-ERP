class Ability
  include CanCan::Ability

  def initialize(user)
    if user.role == 'SuperAdmin'
      can :manage, :all
    elsif user.role == 'Admin'
      can [:read, :create, :update], :all
    elsif user.role == 'Employee'
      can :read, [TimeTable, Employee, ArchivedEmployee, Newscast, Comment]
      can [:read, :create, :update], [ExamGroup, Exam, ExamScore, Event]
      p = user.privileges.collect { |i|[i.name, i.privilege_tag.name_tag] }
      p.each do |i|
        can [i[0].to_sym], (Object.const_get i[1])
      end
    else
      can [:read, :update], [Student, ArchivedStudent]
      can :read, [TimeTable, Event, Comment, Newscast, TimeTableEntry]
    end
  end
end
