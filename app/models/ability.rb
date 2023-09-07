# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def self.for(user)
    "Ability::#{user.role.classify}".constantize.new user
  end

  def initialize(user)
    @user = user ||= User.new # guest user (not logged in)
  end

  protected

  def managed_websites_ids
    @managed_websites_ids ||= @user.websites_to_manage.pluck(:communication_website_id)
  end
end
