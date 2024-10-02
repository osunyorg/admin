class Ability::Author < Ability

  def initialize(user)
    super
    can :manage, Communication::Block, university_id: @user.university_id, about_type: 'Communication::Website::Agenda::Event::Localization', about_id: managed_agenda_event_localization_ids
    can :manage, Communication::Block, university_id: @user.university_id, about_type: 'Communication::Website::Portfolio::Project::Localization', about_id: managed_portfolio_project_localization_ids
    can :manage, Communication::Block, university_id: @user.university_id, about_type: 'Communication::Website::Post::Localization', about_id: managed_post_localization_ids
    can :create, Communication::Block
    can :manage, Communication::Block::Heading, university_id: @user.university_id, about_type: 'Communication::Website::Agenda::Event::Localization', about_id: managed_agenda_event_localization_ids
    can :manage, Communication::Block::Heading, university_id: @user.university_id, about_type: 'Communication::Website::Portfolio::Project::Localization', about_id: managed_portfolio_project_localization_ids
    can :manage, Communication::Block::Heading, university_id: @user.university_id, about_type: 'Communication::Website::Post::Localization', about_id: managed_post_localization_ids
    can :create, Communication::Block::Heading
    can :read, Communication::Website, university_id: @user.university_id, id: managed_websites_ids
    can :manage, Communication::Website::Post, university_id: @user.university_id, communication_website_id: managed_websites_ids, author_id: @user.person&.id
    can :manage, Communication::Website::Agenda::Event, university_id: @user.university_id, communication_website_id: managed_websites_ids, created_by_id: @user.id
    can :manage, Communication::Website::Portfolio::Project, university_id: @user.university_id, communication_website_id: managed_websites_ids, created_by_id: @user.id
    can :manage, User::Favorite, user_id: @user
  end

  protected

  def managed_agenda_event_localization_ids
    @managed_agenda_event_localization_ids ||= begin
      managed_agenda_event_ids = Communication::Website::Agenda::Event
                          .where(university_id: @user.university_id, created_by_id: @user.id)
                          .pluck(:id)
      Communication::Website::Agenda::Event::Localization.where(about_id: managed_agenda_event_ids).pluck(:id)
    end
  end

  def managed_portfolio_project_localization_ids
    @managed_portfolio_project_localization_ids ||= begin
      managed_portfolio_project_ids = Communication::Website::Portfolio::Project
                          .where(university_id: @user.university_id, created_by_id: @user.id)
                          .pluck(:id)
      Communication::Website::Portfolio::Project::Localization.where(about_id: managed_portfolio_project_ids).pluck(:id)
    end
  end

  def managed_post_localization_ids
    @managed_post_localization_ids ||= begin
      managed_post_ids = Communication::Website::Post
                          .where(university_id: @user.university_id, author_id: @user.person&.id)
                          .pluck(:id)
      Communication::Website::Post::Localization.where(about_id: managed_post_ids).pluck(:id)
    end
  end

end