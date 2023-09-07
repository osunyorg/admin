class Ability::ProgramManager < Ability

  def initialize(user)
    super
    can :manage, Communication::Block, university_id: @user.university_id, about_type: 'Communication::Website::Post', about_id: Communication::Website::Post.where(university_id: @user.university_id).pluck(:id)
    can :manage, Communication::Block, university_id: @user.university_id, about_type: 'Communication::Website::Agenda::Event', about_id: Communication::Website::Agenda::Event.where(university_id: @user.university_id).pluck(:id)
    can :manage, Communication::Block, university_id: @user.university_id, about_type: 'University::Person', about_id: University::Person.where(university_id: @user.university_id).pluck(:id)
    can :manage, Communication::Block, university_id: @user.university_id, about_type: 'Education::Program', about_id: managed_programs_ids
    can :create, Communication::Block
    can :manage, Communication::Block::Heading, university_id: @user.university_id, about_type: 'Communication::Website::Post', about_id: Communication::Website::Post.where(university_id: @user.university_id).pluck(:id)
    can :manage, Communication::Block::Heading, university_id: @user.university_id, about_type: 'Communication::Website::Agenda::Event', about_id: Communication::Website::Agenda::Event.where(university_id: @user.university_id).pluck(:id)
    can :manage, Communication::Block::Heading, university_id: @user.university_id, about_type: 'Education::Program', about_id: managed_programs_ids
    can :manage, Communication::Block::Heading, university_id: @user.university_id, about_type: 'University::Person', about_id: University::Person.where(university_id: @user.university_id).pluck(:id)
    can :create, Communication::Block::Heading
    can :read, Communication::Website, university_id: @user.university_id
    can :manage, Communication::Website::Post, university_id: @user.university_id
    can :manage, Communication::Website::Agenda::Event, university_id: @user.university_id
    can :manage, Education::Program, id: managed_programs_ids
    can [:read, :children], Education::Program, university_id: @user.university_id
    cannot :create, Education::Program
    can :manage, University::Person, university_id: @user.university_id
    can :manage, University::Person::Involvement, target_type: "Education::Program", target_id: managed_programs_ids
    can :manage, University::Role, target_type: "Education::Program", target_id: managed_programs_ids  end

  protected

  def managed_programs_ids
    @managed_programs_ids ||= @user.programs_to_manage.pluck(:education_program_id)
  end
end