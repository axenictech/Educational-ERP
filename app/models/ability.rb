class Ability
  include CanCan::Ability

  def initialize(user)
    if user.role == 'SuperAdmin'
      can :manage, :all
    elsif user.role == 'Admin'
      can [:read, :create, :update], :all
    elsif user.role == 'Employee'

       p = User.find(user.id).privileges
       p.where(privilege_tag_id:18).pluck(:name)


         
      emp_id = User.where(id: user.id).pluck(:employee_id)
      em = Employee.where(id: emp_id.map(&:to_i)).take
      position = EmployeePosition.where(id: em.employee_position_id).take.name

      all = Employee.all.pluck(:employee_position_id)
      all_emp_pos = []
      all.each do |i|
        all_emp_pos << EmployeePosition.where(id: i).take.name
      end

      if position == 'Research Associate'
        can :manage, :all
      else
        can :read, [TimeTable, Employee, ArchivedEmployee]
        can [:read, :create, :update], [ExamGroup, Exam, ExamScore]

      end
    else
      can [:read, :update], [Student, ArchivedStudent]
      can :read, TimeTable
    end
  end
end
