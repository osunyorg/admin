class Ability::Contributor < Ability

  def initialize(user)
    super
    can :manage, Communication::Block, university_id: @user.university_id, about_type: 'Communication::Website::Post', about_id: Communication::Website::Post.where(university_id: @user.university_id, author_id: @user.person&.id).pluck(:id)
    can :manage, Communication::Block, university_id: @user.university_id, about_type: 'Communication::Website::Agenda::Event'
    can :create, Communication::Block
    can :manage, Communication::Block::Heading, university_id: @user.university_id, about_type: 'Communication::Website::Post', about_id: Communication::Website::Post.where(university_id: @user.university_id, author_id: @user.person&.id).pluck(:id)
    can :manage, Communication::Block::Heading, university_id: @user.university_id, about_type: 'Communication::Website::Agenda::Event'
    can :create, Communication::Block::Heading
    can :read, Communication::Website, university_id: @user.university_id, id: managed_websites_ids
    can :manage, Communication::Website::Post, university_id: @user.university_id, communication_website_id: managed_websites_ids, author_id: @user.person&.id
    cannot :publish, Communication::Website::Post
  end
end