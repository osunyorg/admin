class Ability::AlumniManager < Ability

  def initialize(user)
    super
    manage_blocks
    can :manage, University::Person, university_id: @user.university_id
    can :manage, University::Person::Category, university_id: @user.university_id
    can :manage, University::Person::Experience, university_id: @user.university_id
    can :manage, University::Person::Involvement, university_id: @user.university_id
    can :manage, University::Person::Alumnus
    can :manage, Import, university_id: @user.university_id
    can :manage, Education::AcademicYear, university_id: @user.university_id
    can :manage, Education::Cohort, university_id: @user.university_id
  end

  protected

  def manage_blocks
    can :manage, Communication::Block, university_id: @user.university_id, about_type: 'University::Person::Localization', about_id: University::Person::Localization.where(university_id: @user.university_id).pluck(:id)
    can :manage, Communication::Block, university_id: @user.university_id, about_type: 'University::Person::Category::Localization', about_id: University::Person::Category::Localization.where(university_id: @user.university_id).pluck(:id)
    can :create, Communication::Block
  end

end
