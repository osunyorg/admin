class Ability::Teacher < Ability

  def initialize(user)
    super
    can :manage, Communication::Block, university_id: @user.university_id, about_type: 'Education::Program::Localization', about_id: managed_program_localization_ids
    can :manage, Communication::Block, university_id: @user.university_id, about_type: 'University::Person::Localization', about_id: managed_person_localization_ids
    can :create, Communication::Block
    can :manage, Communication::Block::Heading, university_id: @user.university_id, about_type: 'Education::Program::Localization', about_id: managed_program_localization_ids
    can :manage, Communication::Block::Heading, university_id: @user.university_id, about_type: 'University::Person::Localization', about_id: managed_person_localization_ids
    can :create, Communication::Block::Heading
    can [:read, :children], Education::Program, university_id: @user.university_id
    can :manage, University::Person, user_id: @user.id
    cannot :create, University::Person
    can :manage, University::Person::Involvement, person_id: @user.person&.id
    can :read, University::Person::Involvement, university_id: @user.university_id
    can :read, University::Role, university_id: @user.university_id
  end

  protected

  def managed_program_localization_ids
    @managed_program_localization_ids ||= begin
      Education::Program::Localization
        .where(university_id: @user.university_id)
        .pluck(:id)
    end
  end

  def managed_person_localization_ids
    @managed_person_localization_ids ||= begin
      University::Person::Localization
        .where(university_id: @user.university_id, about_id: @user.person&.id)
        .pluck(:id)
    end
  end
end