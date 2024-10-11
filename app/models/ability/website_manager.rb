class Ability::WebsiteManager < Ability

  def initialize(user)
    super
    manage_blocks
    can [:read, :analytics], Communication::Website, university_id: @user.university_id, id: managed_websites_ids
    can :manage, Communication::Website::Localization, university_id: @user.university_id, communication_website_id: managed_websites_ids
    can :manage, Communication::Website::Agenda::Event, university_id: @user.university_id, communication_website_id: managed_websites_ids
    can :manage, Communication::Website::Agenda::Category, university_id: @user.university_id, communication_website_id: managed_websites_ids
    can :manage, Communication::Website::Post::Category, university_id: @user.university_id, communication_website_id: managed_websites_ids
    can [:read, :update, :reorder], Communication::Website::Menu, university_id: @user.university_id, communication_website_id: managed_websites_ids
    can :manage, Communication::Website::Menu::Item, university_id: @user.university_id, website_id: managed_websites_ids
    can :create, Communication::Website::Menu::Item, university_id: @user.university_id
    can :manage, Communication::Website::Page, university_id: @user.university_id, communication_website_id: managed_websites_ids
    can :manage, Communication::Website::Portfolio::Category, university_id: @user.university_id, communication_website_id: managed_websites_ids
    can :manage, Communication::Website::Portfolio::Project, university_id: @user.university_id, communication_website_id: managed_websites_ids
    can :manage, Communication::Website::Post, university_id: @user.university_id, communication_website_id: managed_websites_ids
    can :manage, University::Organization, university_id: @user.university_id
    can :manage, University::Person, university_id: @user.university_id
    can :manage, University::Person::Category, university_id: @user.university_id
    can :manage, University::Person::Experience, university_id: @user.university_id
    can :manage, University::Person::Involvement, university_id: @user.university_id
    can :manage, User::Favorite, user_id: @user
  end

  protected

  def managed_agenda_category_localization_ids
    @managed_agenda_category_localization_ids ||= begin
      Communication::Website::Agenda::Category::Localization
        .where(communication_website_id: managed_websites_ids)
        .pluck(:id)
    end
  end

  def managed_agenda_event_localization_ids
    @managed_agenda_event_localization_ids ||= begin
      Communication::Website::Agenda::Event::Localization
        .where(communication_website_id: managed_websites_ids)
        .pluck(:id)
    end
  end

  def managed_page_localization_ids
    @managed_page_localization_ids ||= begin
      Communication::Website::Page::Localization
        .where(communication_website_id: managed_websites_ids)
        .pluck(:id)
    end
  end

  def managed_portfolio_category_localization_ids
    @managed_portfolio_category_localization_ids ||= begin
      Communication::Website::Portfolio::Category::Localization
        .where(communication_website_id: managed_websites_ids)
        .pluck(:id)
    end
  end

  def managed_portfolio_project_localizations_ids
    @managed_portfolio_project_localizations_ids ||= begin
      Communication::Website::Portfolio::Project::Localization
        .where(communication_website_id: managed_websites_ids)
        .pluck(:id)
    end
  end

  def managed_post_category_localization_ids
    @managed_post_category_localization_ids ||= begin
      Communication::Website::Post::Category::Localization
        .where(communication_website_id: managed_websites_ids)
        .pluck(:id)
    end
  end

  def managed_post_localization_ids
    @managed_post_localization_ids ||= begin
      Communication::Website::Post::Localization
        .where(communication_website_id: managed_websites_ids)
        .pluck(:id)
    end
  end

  def manage_blocks
    can :manage, Communication::Block, university_id: @user.university_id, about_type: 'Communication::Website::Agenda::Category::Localization', about_id: managed_agenda_category_localization_ids
    can :manage, Communication::Block, university_id: @user.university_id, about_type: 'Communication::Website::Agenda::Event::Localization', about_id: managed_agenda_event_localization_ids
    can :manage, Communication::Block, university_id: @user.university_id, about_type: 'Communication::Website::Page::Localization', about_id: managed_page_localization_ids
    can :manage, Communication::Block, university_id: @user.university_id, about_type: 'Communication::Website::Portfolio::Category::Localization', about_id: managed_portfolio_category_localization_ids
    can :manage, Communication::Block, university_id: @user.university_id, about_type: 'Communication::Website::Portfolio::Project::Localization', about_id: managed_portfolio_project_localizations_ids
    can :manage, Communication::Block, university_id: @user.university_id, about_type: 'Communication::Website::Post::Category::Localization', about_id: managed_post_category_localization_ids
    can :manage, Communication::Block, university_id: @user.university_id, about_type: 'Communication::Website::Post::Localization', about_id: managed_post_localization_ids
    can :manage, Communication::Block, university_id: @user.university_id, about_type: 'University::Organization::Localization', about_id: University::Organization::Localization.where(university_id: @user.university_id).pluck(:id)
    can :manage, Communication::Block, university_id: @user.university_id, about_type: 'University::Person::Localization', about_id: University::Person::Localization.where(university_id: @user.university_id).pluck(:id)
    can :create, Communication::Block
    can :manage, Communication::Block::Heading, university_id: @user.university_id, about_type: 'Communication::Website::Agenda::Category::Localization', about_id: managed_agenda_category_localization_ids
    can :manage, Communication::Block::Heading, university_id: @user.university_id, about_type: 'Communication::Website::Agenda::Event::Localization', about_id: managed_agenda_event_localization_ids
    can :manage, Communication::Block::Heading, university_id: @user.university_id, about_type: 'Communication::Website::Page::Localization', about_id: managed_page_localization_ids
    can :manage, Communication::Block::Heading, university_id: @user.university_id, about_type: 'Communication::Portfolio::Category::Localization', about_id: managed_portfolio_category_localization_ids
    can :manage, Communication::Block::Heading, university_id: @user.university_id, about_type: 'Communication::Portfolio::Project::Localization', about_id: managed_portfolio_project_localizations_ids
    can :manage, Communication::Block::Heading, university_id: @user.university_id, about_type: 'Communication::Website::Post::Category::Localization', about_id: managed_post_category_localization_ids
    can :manage, Communication::Block::Heading, university_id: @user.university_id, about_type: 'Communication::Website::Post::Localization', about_id: managed_post_localization_ids
    can :manage, Communication::Block::Heading, university_id: @user.university_id, about_type: 'University::Organization::Localization', about_id: University::Organization::Localization.where(university_id: @user.university_id).pluck(:id)
    can :manage, Communication::Block::Heading, university_id: @user.university_id, about_type: 'University::Person::Localization', about_id: University::Person::Localization.where(university_id: @user.university_id).pluck(:id)
    can :create, Communication::Block::Heading
  end

end