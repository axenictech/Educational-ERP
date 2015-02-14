class Ability
  include CanCan::Ability

  def initialize(user)
    if user.role == 'SuperAdmin'
      can :manage, :all
    elsif user.role == 'Admin'
      can [:read, :create, :update], :all
    elsif user.role == 'Employee'
      p = user.privileges.collect { |i|[i.name, i.privilege_tag.name_tag] }
      p.each do |i|
        can [i[0].to_sym], (Object.const_get i[1])
      end
    else
      can [:read, :update], [Student, ArchivedStudent]
      can :read, TimeTable
    end
  end
end
