class Ability::Author < Ability

  def initialize(user)
    super
    can :manage, Communication::Website::Agenda::Event, university_id: @user.university_id, id: managed_agenda_event_ids
    can :create, Communication::Website::Agenda::Event, university_id: @user.university_id, communication_website_id: managed_websites_ids
    can :manage, Communication::Website::Agenda::Exhibition, university_id: @user.university_id, id: managed_agenda_event_ids
    can :create, Communication::Website::Agenda::Exhibition, university_id: @user.university_id, communication_website_id: managed_websites_ids
    can :manage, Communication::Website::Portfolio::Project, university_id: @user.university_id, id: managed_portfolio_project_ids
    can :create, Communication::Website::Portfolio::Project, university_id: @user.university_id, communication_website_id: managed_websites_ids
    can :manage, Communication::Website::Post, university_id: @user.university_id, id: managed_post_ids
    can :create, Communication::Website::Post, university_id: @user.university_id, communication_website_id: managed_websites_ids
    can :manage, University::Organization, university_id: @user.university_id, id: managed_organization_ids
    can :create, University::Organization, university_id: @user.university_id
    can :manage, University::Person, university_id: @user.university_id, id: managed_person_ids
    can :create, University::Person, university_id: @user.university_id
    can :manage, Communication::Block, university_id: @user.university_id, about_type: 'Communication::Website::Agenda::Event::Localization', about_id: managed_agenda_event_localization_ids
    can :manage, Communication::Block, university_id: @user.university_id, about_type: 'Communication::Website::Agenda::Exhibition::Localization', about_id: managed_agenda_exhibition_localization_ids
    can :manage, Communication::Block, university_id: @user.university_id, about_type: 'Communication::Website::Portfolio::Project::Localization', about_id: managed_portfolio_project_localization_ids
    can :manage, Communication::Block, university_id: @user.university_id, about_type: 'Communication::Website::Post::Localization', about_id: managed_post_localization_ids
    can :manage, Communication::Block, university_id: @user.university_id, about_type: 'University::Organization::Localization', about_id: managed_organization_localization_ids
    can :manage, Communication::Block, university_id: @user.university_id, about_type: 'University::Person::Localization', about_id: managed_person_localization_ids
    can :create, Communication::Block
    can :read, Communication::Website, university_id: @user.university_id, id: managed_websites_ids
    can :manage, User::Favorite, user_id: @user
    can :manage, Communication::Media, university_id: @user.university_id
    cannot :destroy, Communication::Website
  end

  protected

  def managed_agenda_event_ids
    @managed_agenda_event_ids ||= Communication::Website::Agenda::Event
                                    .where(
                                      university_id: @user.university_id,
                                      communication_website_id: managed_websites_ids,
                                      created_by_id: @user.id
                                    )
                                    .pluck(:id)
  end

  def managed_agenda_exhibition_ids
    @managed_agenda_exhibition_ids ||= Communication::Website::Agenda::Exhibition
                                    .where(
                                      university_id: @user.university_id,
                                      communication_website_id: managed_websites_ids,
                                      created_by_id: @user.id
                                    )
                                    .pluck(:id)
  end

  def managed_agenda_event_localization_ids
    @managed_agenda_event_localization_ids ||= Communication::Website::Agenda::Event::Localization
                                                .where(about_id: managed_agenda_event_ids)
                                                .pluck(:id)
  end

  def managed_agenda_exhibition_localization_ids
    @managed_agenda_exhibition_localization_ids ||= Communication::Website::Agenda::Exhibition::Localization
                                                .where(about_id: managed_agenda_exhibition_ids)
                                                .pluck(:id)
  end

  def managed_portfolio_project_ids
    @managed_portfolio_project_ids ||= Communication::Website::Portfolio::Project
                                        .where(
                                          university_id: @user.university_id,
                                          communication_website_id: managed_websites_ids,
                                          created_by_id: @user.id
                                        )
                                        .pluck(:id)
  end

  def managed_portfolio_project_localization_ids
    @managed_portfolio_project_localization_ids ||= Communication::Website::Portfolio::Project::Localization
                                                      .where(about_id: managed_portfolio_project_ids)
                                                      .pluck(:id)
  end

  def managed_post_ids
    return [] if @user.person.nil?
    @managed_post_ids ||= Communication::Website::Post
                            .joins(:authors)
                            .where(
                              university_id: @user.university_id,
                              communication_website_id: managed_websites_ids,
                              university_people: { id: @user.person.id }
                            )
                            .pluck(:id)
  end

  def managed_post_localization_ids
    @managed_post_localization_ids ||= Communication::Website::Post::Localization
                                        .where(about_id: managed_post_ids)
                                        .pluck(:id)
  end

  def managed_organization_ids
    @managed_organization_ids ||= University::Organization
                                    .where(
                                      university_id: @user.university_id,
                                      created_by_id: @user.id
                                    )
                                    .pluck(:id)
  end

  def managed_organization_localization_ids
    @managed_organization_localization_ids ||= University::Organization::Localization
                                        .where(about_id: managed_organization_ids)
                                        .pluck(:id)
  end

  def managed_person_ids
    @managed_person_ids ||= University::Person
                                          .where(
                                            university_id: @user.university_id,
                                            created_by_id: @user.id
                                          )
                                          .pluck(:id)
  end

  def managed_person_localization_ids
    @managed_person_localization_ids ||= University::Person::Localization
                                        .where(about_id: managed_person_ids)
                                        .pluck(:id)
  end

end