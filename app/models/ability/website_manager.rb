class Ability::WebsiteManager < Ability

  def initialize(user)
    super
    can :manage, Communication::Block, university_id: @user.university_id, about_type: 'Communication::Website::Page', about_id: managed_pages_ids
    can :manage, Communication::Block, university_id: @user.university_id, about_type: 'Communication::Website::Post', about_id: managed_posts_ids
    can :manage, Communication::Block, university_id: @user.university_id, about_type: 'University::Organization', about_id: University::Organization.where(university_id: @user.university_id).pluck(:id)
    can :manage, Communication::Block, university_id: @user.university_id, about_type: 'University::Person', about_id: University::Person.where(university_id: @user.university_id).pluck(:id)
    can :create, Communication::Block
    can :manage, Communication::Block::Heading, university_id: @user.university_id, about_type: 'Communication::Website::Page', about_id: managed_pages_ids
    can :manage, Communication::Block::Heading, university_id: @user.university_id, about_type: 'Communication::Website::Post', about_id: managed_posts_ids
    can :manage, Communication::Block::Heading, university_id: @user.university_id, about_type: 'University::Organization', about_id: University::Organization.where(university_id: @user.university_id).pluck(:id)
    can :manage, Communication::Block::Heading, university_id: @user.university_id, about_type: 'University::Person', about_id: University::Person.where(university_id: @user.university_id).pluck(:id)
    can :create, Communication::Block::Heading
    can [:read, :analytics], Communication::Website, university_id: @user.university_id, id: managed_websites_ids
    can :manage, Communication::Website::Category, university_id: @user.university_id, communication_website_id: managed_websites_ids
    can [:read, :update, :reorder], Communication::Website::Menu, university_id: @user.university_id, communication_website_id: managed_websites_ids
    can :manage, Communication::Website::Menu::Item, university_id: @user.university_id, website_id: managed_websites_ids
    can :create, Communication::Website::Menu::Item, university_id: @user.university_id
    can :manage, Communication::Website::Page, university_id: @user.university_id, communication_website_id: managed_websites_ids
    can :manage, Communication::Website::Post, university_id: @user.university_id, communication_website_id: managed_websites_ids
    can :manage, University::Organization, university_id: @user.university_id
    can :manage, University::Person, university_id: @user.university_id
    can :manage, University::Person::Category, university_id: @user.university_id
    can :manage, University::Person::Experience, university_id: @user.university_id
    can :manage, University::Person::Involvement, university_id: @user.university_id
  end

  protected

  def managed_pages_ids
    @managed_pages_ids ||= Communication::Website::Page.where(communication_website_id: managed_websites_ids).pluck(:id)
  end

  def managed_posts_ids
    @managed_posts_ids ||= Communication::Website::Post.where(communication_website_id: managed_websites_ids).pluck(:id)
  end
end