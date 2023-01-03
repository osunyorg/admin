module Communication::Website::Page::WithType
  extend ActiveSupport::Concern

  
  included do
    TYPE_HOME = 'Communication::Website::Page::Home'
    TYPE_PERSONS = 'Communication::Website::Page::Person'

    TYPES = [
      Communication::Website::Page::Home, # Always start with home
      Communication::Website::Page::Accessibility,
      Communication::Website::Page::Administrator,
      Communication::Website::Page::Author,
      Communication::Website::Page::CommunicationPost,
      Communication::Website::Page::EducationDiploma,
      Communication::Website::Page::EducationProgram,
      Communication::Website::Page::LegalTerm,
      Communication::Website::Page::Organization,
      Communication::Website::Page::Person,
      Communication::Website::Page::PrivacyPolicy,
      Communication::Website::Page::ResearchPaper,
      Communication::Website::Page::ResearchVolume,
      Communication::Website::Page::Researcher,
      Communication::Website::Page::Sitemap,
      Communication::Website::Page::Teacher
    ]

    scope :home, -> { where(type: TYPE_HOME) }
    scope :persons, -> { where(type: TYPE_PERSONS) }

    after_initialize :initialize_page
    after_create :positionize_page
  end

  # Communication::Website::Page::CommunicationPosts -> communication_posts
  # Used for i18n
  def type_key
    type.demodulize.underscore
  end

  def is_home?
    type == TYPE_HOME
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

  def editable_width?
    true
  end

  def full_width_by_default?
    false
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

  protected

  def default_parent
    website.home_page
  end

  def default_position
    nil
  end

  def type_git_dependencies
    []
  end

  def initialize_page
    i18n_key = "communication.website.pages.defaults.#{type_key}"
    self.title = I18n.t("#{i18n_key}.title")
    self.slug = I18n.t("#{i18n_key}.slug")
    self.parent = default_parent
    self.full_width = full_width_by_default?
    self.published = published_by_default?
  end

  def positionize_page
    return if is_regular_page?
    self.update_column :position, default_position if default_position
  end
end