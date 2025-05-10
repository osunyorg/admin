class Ability::Admin < Ability

  def initialize(user)
    super
    admin_university
    admin_education
    admin_research
    admin_communication
    admin_communication_extranet
    admin_administration
    can :manage, Import, university_id: @user.university_id
  end

  protected

  def admin_university
    can :manage, University::Organization, university_id: @user.university_id
    can :manage, University::Organization::Category, university_id: @user.university_id
    can :manage, University::Person, university_id: @user.university_id
    can :manage, University::Person::Category, university_id: @user.university_id
    can :manage, University::Person::Experience, university_id: @user.university_id
    can :manage, University::Person::Involvement, university_id: @user.university_id
    can :manage, University::Role, university_id: @user.university_id
    can :manage, User, university_id: @user.university_id, role: @user.managed_roles
    can :manage, User::Favorite, user_id: @user
    can :manage, University::App, university_id: @user.university_id
  end

  def admin_education
    # Necessaire pour l'affichage des tableaux de bord
    # https://github.com/osunyorg/admin/pull/2491
    can :manage, University::Person::Localization::Teacher
    can :manage, Education::AcademicYear, university_id: @user.university_id
    can :manage, Education::Cohort, university_id: @user.university_id
    can :manage, Education::Diploma, university_id: @user.university_id
    can :manage, Education::Program, university_id: @user.university_id
    can :manage, Education::Program::Category, university_id: @user.university_id
    can :manage, Education::School, university_id: @user.university_id
    can :manage, :all_programs # needed to prevent program_manager to access specific global screens
  end

  def admin_research
    # Necessaire pour l'affichage des tableaux de bord
    # https://github.com/osunyorg/admin/pull/2491
    can :manage, University::Person::Localization::Researcher
    can :manage, Research::Hal::Author
    can :manage, Research::Publication
    can :manage, Research::Journal, university_id: @user.university_id
    can :manage, Research::Journal::Paper, university_id: @user.university_id
    can :manage, Research::Journal::Paper::Kind, university_id: @user.university_id
    can :manage, Research::Journal::Volume, university_id: @user.university_id
    can :manage, Research::Laboratory, university_id: @user.university_id
    can :manage, Research::Laboratory::Axis, university_id: @user.university_id
    can :manage, Research::Thesis, university_id: @user.university_id
  end

  def admin_communication
    # Necessaire pour l'affichage des tableaux de bord
    # https://github.com/osunyorg/admin/pull/2491
    can :manage, University::Person::Localization::Author
    can :manage, Communication::Block, university_id: @user.university_id
    can :create, Communication::Block
    can :manage, Communication::Website, university_id: @user.university_id
    # Est-ce bien raisonnable de laisser supprimer un site ?
    # Le risque de faussse manip est grand.
    cannot :destroy, Communication::Website, university_id: @user.university_id
    can :manage, Communication::Website::Localization, university_id: @user.university_id
    can :manage, Communication::Website::Agenda::Event, university_id: @user.university_id
    can :manage, Communication::Website::Agenda::Category, university_id: @user.university_id
    can :manage, Communication::Website::Agenda::Exhibition, university_id: @user.university_id
    can :manage, Communication::Website::Portfolio::Category, university_id: @user.university_id
    can :manage, Communication::Website::Portfolio::Project, university_id: @user.university_id
    can :manage, Communication::Website::Post::Category, university_id: @user.university_id
    can :manage, Communication::Website::Menu, university_id: @user.university_id
    can :manage, Communication::Website::Menu::Item, university_id: @user.university_id
    can :manage, Communication::Website::Page, university_id: @user.university_id
    can :manage, Communication::Website::Page::Category, university_id: @user.university_id
    can :manage, Communication::Website::Post, university_id: @user.university_id
    can :manage, Communication::Media, university_id: @user.university_id
    can :manage, Communication::Media::Category, university_id: @user.university_id
    can :manage, Communication::Media::Collection, university_id: @user.university_id
  end

  def admin_communication_extranet
    can [:read, :update], Communication::Extranet, university_id: @user.university_id
    can :manage, Communication::Extranet::Connection, university_id: @user.university_id
    can :manage, Communication::Extranet::Document, university_id: @user.university_id
    can :manage, Communication::Extranet::Document::Category, university_id: @user.university_id
    can :manage, Communication::Extranet::Document::Kind, university_id: @user.university_id
    can :manage, Communication::Extranet::Post, university_id: @user.university_id
    can :manage, Communication::Extranet::Post::Category, university_id: @user.university_id
  end

  def admin_administration
    # Necessaire pour l'affichage des tableaux de bord
    # https://github.com/osunyorg/admin/pull/2491
    can :manage, University::Person::Alumnus
    can :manage, Administration::Location
    can :read, Administration::Qualiopi
    can :read, Administration::Qualiopi::Criterion
    can :read, Administration::Qualiopi::Indicator
  end
end