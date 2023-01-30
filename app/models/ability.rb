# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    @user = user ||= User.new # guest user (not logged in)
    send @user.role.to_sym
  end

  protected

  def visitor
  end

  def contributor
    managed_websites_ids = @user.websites_to_manage.pluck(:communication_website_id)
    can :read, Communication::Website, university_id: @user.university_id, id: managed_websites_ids
    can :manage, Communication::Website::Post, university_id: @user.university_id, communication_website_id: managed_websites_ids, author_id: @user.person&.id
    cannot :publish, Communication::Website::Post
    can :manage, Research::Journal
  end

  def author
    managed_websites_ids = @user.websites_to_manage.pluck(:communication_website_id)
    can :read, Communication::Website, university_id: @user.university_id, id: managed_websites_ids
    can :manage, Communication::Website::Post, university_id: @user.university_id, communication_website_id: managed_websites_ids, author_id: @user.person&.id
    can :manage, Research::Journal
  end

  def teacher
    can :manage, University::Person, user_id: @user.id
    cannot :create, University::Person
    can [:read, :children], Education::Program, university_id: @user.university_id
    can :read, University::Role, university_id: @user.university_id
    can :manage, University::Person::Involvement, person_id: @user.person&.id
    can :read, University::Person::Involvement, university_id: @user.university_id
    can :manage, Communication::Block, university_id: @user.university_id, about_type: 'Education::Program', about_id: Education::Program.where(university_id: @user.university_id).pluck(:id)
    can :manage, Research::Journal
  end

  def program_manager
    managed_programs_ids = @user.programs_to_manage.pluck(:education_program_id)
    can :manage, University::Person, university_id: @user.university_id
    can :manage, Education::Program, id: managed_programs_ids
    can [:read, :children], Education::Program, university_id: @user.university_id
    cannot :create, Education::Program
    can :manage, University::Role, target_type: "Education::Program", target_id: managed_programs_ids
    can :manage, University::Person::Involvement, target_type: "Education::Program", target_id: managed_programs_ids
    can :read, Communication::Website, university_id: @user.university_id
    can :manage, Communication::Website::Post, university_id: @user.university_id
    can :manage, Communication::Block, university_id: @user.university_id, about_type: 'Education::Program', about_id: managed_programs_ids
    can :create, Communication::Block
    can :manage, Research::Journal
  end

  def website_manager
    managed_websites_ids = @user.websites_to_manage.pluck(:communication_website_id)
    managed_pages_ids = Communication::Website::Page.where(communication_website_id: managed_websites_ids).pluck(:id)
    managed_posts_ids = Communication::Website::Post.where(communication_website_id: managed_websites_ids).pluck(:id)
    can :read, Communication::Website, university_id: @user.university_id, id: managed_websites_ids
    can :analytics, Communication::Website, university_id: @user.university_id, id: managed_websites_ids
    can :manage, Communication::Website::Page, university_id: @user.university_id, communication_website_id: managed_websites_ids
    can :manage, Communication::Website::Post, university_id: @user.university_id, communication_website_id: managed_websites_ids
    can :manage, Communication::Website::Category, university_id: @user.university_id, communication_website_id: managed_websites_ids
    can [:read, :update, :reorder], Communication::Website::Menu, university_id: @user.university_id, communication_website_id: managed_websites_ids
    can :manage, Communication::Website::Menu::Item, university_id: @user.university_id, website_id: managed_websites_ids
    can :create, Communication::Website::Menu::Item, university_id: @user.university_id
    can :manage, University::Organization, university_id: @user.university_id
    can :manage, Communication::Block, university_id: @user.university_id, about_type: 'Communication::Website::Page', about_id: managed_pages_ids
    can :manage, Communication::Block, university_id: @user.university_id, about_type: 'Communication::Website::Post', about_id: managed_posts_ids
    can :create, Communication::Block
    can :manage, Research::Journal
  end

  def admin
    can :read, Administration::Qualiopi::Criterion
    can :read, Administration::Qualiopi::Indicator
    can :manage, University::Person
    can :manage, Communication::Block, university_id: @user.university_id
    can :create, Communication::Block
    can :read, Communication::Website, university_id: @user.university_id
    can :analytics, Communication::Website, university_id: @user.university_id
    can :manage, Communication::Website::Page, university_id: @user.university_id
    can :manage, Communication::Website::Post, university_id: @user.university_id
    can :manage, Communication::Website::Category, university_id: @user.university_id
    can [:read, :update, :reorder], Communication::Website::Menu, university_id: @user.university_id
    can :manage, Communication::Website::Menu::Item, university_id: @user.university_id
    can :manage, Communication::Website::Imported::Website, university_id: @user.university_id
    can :manage, Communication::Website::Imported::Page, university_id: @user.university_id
    can :manage, Communication::Website::Imported::Post, university_id: @user.university_id
    can :manage, Education::AcademicYear, university_id: @user.university_id
    can :manage, Education::Cohort, university_id: @user.university_id
    can :manage, Education::School, university_id: @user.university_id
    can :manage, Education::Diploma, university_id: @user.university_id
    can :manage, Education::Program, university_id: @user.university_id
    can :manage, :all_programs # needed to prevent program_manager to access specific global screens
    can :manage, Research::Journal, university_id: @user.university_id
    can :manage, Research::Journal::Paper, university_id: @user.university_id
    can :manage, Research::Journal::Paper::Kind, university_id: @user.university_id
    can :manage, Research::Journal::Volume, university_id: @user.university_id
    can :manage, Research::Laboratory, university_id: @user.university_id
    can :manage, Research::Laboratory::Axis, university_id: @user.university_id
    can :manage, Research::Thesis, university_id: @user.university_id
    can :manage, University::Role, university_id: @user.university_id
    can :manage, University::Person::Involvement, university_id: @user.university_id
    can :manage, University::Organization, university_id: @user.university_id
    can :read, User, university_id: @user.university_id
    can :manage, User, university_id: @user.university_id, role: @user.managed_roles
  end

  def server_admin
    can :manage, :all
  end
end
