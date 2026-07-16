# frozen_string_literal: true

class User::Ability
  include CanCan::Ability

  attr_reader :user

  def self.for(user)
    user ||= User.new # guest user (not logged in)
    new(user)
  end

  def initialize(user)
    @user = user ||= User.new # guest user (not logged in)
    if user.server_admin?
      can :manage, :all
    else
      # Les rôles sont fusionnés du moins au plus privilégié (cf. User#ability_roles)
      # pour que, en cas de conflit, la règle du rôle le plus puissant — déclarée
      # en dernier — l'emporte (CanCanCan : last rule wins).
      user.ability_roles.each do |role_name|
        merge "User::Ability::#{role_name.classify}".constantize.new(user)
      end
    end
  end

  protected

  # Ids des cibles attachées à un rôle donné de l'utilisateur.
  # Chaque ability scope ses règles aux cibles de SON rôle (cf. User#scopes_for),
  # ce qui permet d'être par exemple author du site A et website_manager du site B
  # sans que les périmètres ne débordent l'un sur l'autre.
  def scoped_ids(role_name)
    @user.scopes_for(role_name).map(&:id)
  end
end
