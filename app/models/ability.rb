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
    can :read, Communication::Website, university_id: @user.university_id
    can :read, Communication::Website::Page, university_id: @user.university_id
    can :read, Communication::Website::Post, university_id: @user.university_id
    can :read, Communication::Website::Imported::Website, university_id: @user.university_id
    can :read, Communication::Website::Imported::Page, university_id: @user.university_id
    can :read, Communication::Website::Imported::Post, university_id: @user.university_id
    can :read, Education::Program, university_id: @user.university_id
    can :read, Research::Researcher
    can :read, Research::Journal, university_id: @user.university_id
    can :read, Research::Journal::Article, university_id: @user.university_id
    can :read, Research::Journal::Volume, university_id: @user.university_id
    can :read, User, university_id: @user.university_id
  end

  def admin
    can :read, Administration::Qualiopi::Criterion
    can :read, Administration::Qualiopi::Indicator
    can :read, Communication::Website, university_id: @user.university_id
    can :manage, Communication::Website::Page, university_id: @user.university_id
    can :manage, Communication::Website::Post, university_id: @user.university_id
    can :manage, Communication::Website::Imported::Website, university_id: @user.university_id
    can :manage, Communication::Website::Imported::Page, university_id: @user.university_id
    can :manage, Communication::Website::Imported::Post, university_id: @user.university_id
    can :manage, Education::Program, university_id: @user.university_id
    can :manage, Research::Researcher
    can :manage, Research::Journal, university_id: @user.university_id
    can :manage, Research::Journal::Article, university_id: @user.university_id
    can :manage, Research::Journal::Volume, university_id: @user.university_id
    can :read, User, university_id: @user.university_id
    can :manage, User, university_id: @user.university_id, role: @user.managed_roles
  end

  def server_admin
    can :manage, :all
  end
end
