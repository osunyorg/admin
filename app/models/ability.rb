# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def self.for(user)
    "Ability::#{user.role.classify}".constantize.new user
  end

  def initialize(user)
    @user ||= User.new # guest user (not logged in)
  end

  protected

  def managed_websites_ids
    @managed_websites_ids ||= @user.websites_to_manage.pluck(:communication_website_id)
  end

  def managed_pages_ids
    @managed_pages_ids ||= Communication::Website::Page.where(communication_website_id: managed_websites_ids).pluck(:id)
  end

  def managed_posts_ids
    @managed_posts_ids ||= Communication::Website::Post.where(communication_website_id: managed_websites_ids).pluck(:id)
  end

  def managed_programs_ids
    @managed_programs_ids ||= user.programs_to_manage.pluck(:education_program_id)
  end
end
