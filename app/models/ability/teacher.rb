class Ability::Teacher < Ability

  def initialize(user)
    super
    can :manage, Communication::Block, university_id: @user.university_id, about_type: 'Education::Program', about_id: Education::Program.where(university_id: @user.university_id).pluck(:id)
    can :manage, Communication::Block, university_id: @user.university_id, about_type: 'University::Person', about_id: University::Person.where(university_id: @user.university_id, user_id: @user.id).pluck(:id)
    can :create, Communication::Block
    can :manage, Communication::Block::Heading, university_id: @user.university_id, about_type: 'Education::Program', about_id: Education::Program.where(university_id: @user.university_id).pluck(:id)
    can :manage, Communication::Block::Heading, university_id: @user.university_id, about_type: 'University::Person', about_id: University::Person.where(university_id: @user.university_id, user_id: @user.id).pluck(:id)
    can :create, Communication::Block::Heading
    can [:read, :children], Education::Program, university_id: @user.university_id
    can :manage, University::Person, user_id: @user.id
    cannot :create, University::Person
    can :manage, University::Person::Involvement, person_id: @user.person&.id
    can :read, University::Person::Involvement, university_id: @user.university_id
    can :read, University::Role, university_id: @user.university_id
  end
end