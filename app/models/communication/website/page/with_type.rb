module Communication::Website::Page::WithType
  extend ActiveSupport::Concern

  
  included do
    HOME_TYPE = '::Communication::Website::Page::Home'

    scope :home, -> { where(type: HOME_TYPE) }
  end

  # Communication::Website::Page::CommunicationPosts -> communication_posts
  # Used for i18n
  def type_key
    type.demodulize.underscore
  end

  def is_home?
    type == HOME_TYPE
  end

  def is_special_page?
    type.present?
  end

  def is_regular_page?
    type.blank?
  end

  def is_necessary_for_website?
    true
  end

  def full_width_by_default?
    true
  end

  def published_by_default?
    true
  end

  # Can it be unpublished?
  def draftable?
    true
  end

  # All special pages are undeletable
  def deletable?
    is_regular_page?
  end

  def type_git_dependencies
    []
  end
end