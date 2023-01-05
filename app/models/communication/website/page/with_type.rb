module Communication::Website::Page::WithType
  extend ActiveSupport::Concern


  included do
    TYPE_HOME = 'Communication::Website::Page::Home'
    TYPE_PERSONS = 'Communication::Website::Page::Person'

    # Types are listed in the order we want them to be created
    TYPES = [
      # Home always first
      Communication::Website::Page::Home,
      # Global objects
      Communication::Website::Page::CommunicationPost,
      Communication::Website::Page::Person,
      Communication::Website::Page::Organization,
      # Education
      Communication::Website::Page::EducationDiploma,
      Communication::Website::Page::EducationProgram,
      # Research
      Communication::Website::Page::ResearchVolume,
      Communication::Website::Page::ResearchPaper,
      # People facets
      Communication::Website::Page::Administrator,
      Communication::Website::Page::Author,
      Communication::Website::Page::Researcher,
      Communication::Website::Page::Teacher,
      # Legal pages always at the end
      Communication::Website::Page::LegalTerm,
      Communication::Website::Page::PrivacyPolicy,
      Communication::Website::Page::Accessibility,
      Communication::Website::Page::Sitemap
    ]

    scope :home, -> { where(type: TYPE_HOME) }
    scope :persons, -> { where(type: TYPE_PERSONS) }

    before_validation :initialize_special_page, on: :create, if: :is_special_page?
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

  def type_git_dependencies
    []
  end

  def initialize_special_page
    i18n_key = "communication.website.pages.defaults.#{type_key}"
    self.title = I18n.t("#{i18n_key}.title")
    self.slug = I18n.t("#{i18n_key}.slug")
    self.parent = default_parent
    self.full_width = full_width_by_default?
    self.published = published_by_default?
  end
end