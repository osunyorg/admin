# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    @user = user ||= User.new # guest user (not logged in)
    send @user.role.to_sym
  end

  protected

  def visitor
    can :read, Administration::Qualiopi::Criterion
    can :read, Administration::Qualiopi::Indicator
    can :read, University::Person
    can :read, Communication::Website, university_id: @user.university_id
    can :read, Communication::Website::Page, university_id: @user.university_id
    can :read, Communication::Website::Post, university_id: @user.university_id
    can :read, Communication::Website::Home, university_id: @user.university_id
    can :read, Communication::Website::Imported::Website, university_id: @user.university_id
    can :read, Communication::Website::Imported::Page, university_id: @user.university_id
    can :read, Communication::Website::Imported::Post, university_id: @user.university_id
    can :read, Education::Program, university_id: @user.university_id
    can :read, Education::School, university_id: @user.university_id
    can :read, Research::Journal, university_id: @user.university_id
    can :read, Research::Journal::Article, university_id: @user.university_id
    can :read, Research::Journal::Volume, university_id: @user.university_id
    can :read, Research::Laboratory, university_id: @user.university_id
    can :read, User, university_id: @user.university_id
  end

  def teacher
    can :manage, University::Person, user_id: @user.id
    cannot :create, University::Person
    can :read, Education::Program, university_id: @user.university_id
    can :read, University::Role, university_id: @user.university_id
    can :manage, University::Person::Involvement, person_id: @user.person&.id
    can :read, University::Person::Involvement, university_id: @user.university_id
  end

  def program_manager
    can :manage, University::Person, university_id: @user.university_id
    can :manage, Education::Program, university_id: @user.university_id
    can :manage, University::Role, university_id: @user.university_id
    can :manage, University::Person::Involvement, university_id: @user.university_id
    can :read, Communication::Website, university_id: @user.university_id
    can :manage, Communication::Website::Post, university_id: @user.university_id

  end

  def admin
    can :read, Administration::Qualiopi::Criterion
    can :read, Administration::Qualiopi::Indicator
    can :manage, University::Person
    can :read, Communication::Website, university_id: @user.university_id
    can :manage, Communication::Website::Page, university_id: @user.university_id
    can :manage, Communication::Website::Post, university_id: @user.university_id
    can :manage, Communication::Website::Category, university_id: @user.university_id
    can :manage, Communication::Website::Home, university_id: @user.university_id
    can [:read, :update, :reorder], Communication::Website::Menu, university_id: @user.university_id
    can :manage, Communication::Website::Menu::Item, university_id: @user.university_id
    can :manage, Communication::Website::Imported::Website, university_id: @user.university_id
    can :manage, Communication::Website::Imported::Page, university_id: @user.university_id
    can :manage, Communication::Website::Imported::Post, university_id: @user.university_id
    can :manage, Education::School, university_id: @user.university_id
    can :manage, Education::Program, university_id: @user.university_id
    can :manage, Research::Journal, university_id: @user.university_id
    can :manage, Research::Journal::Article, university_id: @user.university_id
    can :manage, Research::Journal::Volume, university_id: @user.university_id
    can :manage, Research::Laboratory, university_id: @user.university_id
    can :manage, University::Role, university_id: @user.university_id
    can :manage, University::Person::Involvement, university_id: @user.university_id
    can :read, User, university_id: @user.university_id
    can :manage, User, university_id: @user.university_id, role: @user.managed_roles
  end

  def server_admin
    can :manage, :all
  end
end
