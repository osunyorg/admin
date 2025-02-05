class Ability::ProgramManager < Ability

  def initialize(user)
    super
    can :manage, Communication::Block, university_id: @user.university_id, about_type: 'Communication::Website::Agenda::Event::Localization', about_id: managed_event_localization_ids
    can :manage, Communication::Block, university_id: @user.university_id, about_type: 'Communication::Website::Agenda::Category::Localization', about_id: managed_agenda_category_localization_ids
    can :manage, Communication::Block, university_id: @user.university_id, about_type: 'Communication::Website::Post::Localization', about_id: managed_post_localization_ids
    can :manage, Communication::Block, university_id: @user.university_id, about_type: 'Communication::Website::Post::Category::Localization', about_id: managed_post_category_localization_ids
    can :manage, Communication::Block, university_id: @user.university_id, about_type: 'Education::Program::Localization', about_id: managed_program_localization_ids
    can :manage, Communication::Block, university_id: @user.university_id, about_type: 'Education::Program::Category::Localization', about_id: managed_program_category_localization_ids
    can :manage, Communication::Block, university_id: @user.university_id, about_type: 'University::Person::Localization', about_id: managed_person_localization_ids
    can :create, Communication::Block
    can :read, Communication::Website, university_id: @user.university_id
    can :manage, Communication::Website::Agenda::Event, university_id: @user.university_id
    can :manage, Communication::Website::Agenda::Category, id: managed_agenda_category_ids
    can :manage, Communication::Website::Post, university_id: @user.university_id
    can :manage, Communication::Website::Post::Category, id: managed_post_category_ids
    can :manage, Education::Program, id: managed_programs_ids
    can [:read, :children], Education::Program, university_id: @user.university_id
    cannot :create, Education::Program
    can :manage, Education::Program::Category, university_id: @user.university_id
    can :manage, University::Person, university_id: @user.university_id
    can :manage, University::Person::Involvement, target_type: "Education::Program", target_id: managed_programs_ids
    can :manage, University::Role, target_type: "Education::Program", target_id: managed_programs_ids
    can :manage, Communication::Media, university_id: @user.university_id
    cannot :destroy, Communication::Website
  end

  protected

  def managed_event_localization_ids
    @managed_event_localization_ids ||= begin
      Communication::Website::Agenda::Event::Localization
        .where(university_id: @user.university_id)
        .pluck(:id)
    end
  end

  def managed_post_localization_ids
    @managed_post_localization_ids ||= begin
      Communication::Website::Post::Localization
        .where(university_id: @user.university_id)
        .pluck(:id)
    end
  end

  def managed_agenda_category_ids
    @managed_agenda_category_ids ||= Communication::Website::Agenda::Category.where(university_id: @user.university_id, program_id: managed_programs_ids).pluck(:id)
  end

  def managed_agenda_category_localization_ids
    @managed_agenda_category_localization_ids ||= Communication::Website::Agenda::Category::Localization.where(about_id: managed_agenda_category_ids).pluck(:id)
  end

  def managed_post_category_ids
    @managed_post_category_ids ||= Communication::Website::Post::Category.where(university_id: @user.university_id, program_id: managed_programs_ids).pluck(:id)
  end

  def managed_post_category_localization_ids
    @managed_post_category_localization_ids ||= Communication::Website::Post::Category::Localization.where(about_id: managed_post_category_ids).pluck(:id)
  end

  def managed_programs_ids
    @managed_programs_ids ||= @user.programs_to_manage.pluck(:id)
  end

  def managed_program_localization_ids
    @managed_program_localization_ids ||= Education::Program::Localization.where(about_id: managed_program_ids).pluck(:id)
  end

  def managed_program_category_ids
    @managed_program_category_ids ||= Education::Program::Category.where(university_id: @user.university_id).pluck(:id)
  end

  def managed_program_category_localization_ids
    @managed_program_category_localization_ids ||= Education::Program::Category::Localization.where(about_id: managed_program_category_ids).pluck(:id)
  end



  def managed_person_localization_ids
    @managed_person_localization_ids ||= begin
      University::Person::Localization
        .where(university_id: @user.university_id)
        .pluck(:id)
    end
  end

end