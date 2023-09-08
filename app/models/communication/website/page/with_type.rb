module Communication::Website::Page::WithType
  extend ActiveSupport::Concern

  included do

    # Types are listed in the order we want them to be created
    TYPES = [
      # Home always first
      Communication::Website::Page::Home,
      # Global objects
      Communication::Website::Page::CommunicationPost,
      Communication::Website::Page::CommunicationAgenda,
      Communication::Website::Page::CommunicationAgendaArchive,
      Communication::Website::Page::Person,
      Communication::Website::Page::Organization,
      # Education
      Communication::Website::Page::EducationDiploma,
      Communication::Website::Page::EducationProgram,
      # Research
      Communication::Website::Page::ResearchVolume,
      Communication::Website::Page::ResearchPaper,
      Communication::Website::Page::ResearchHalPublication,
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

    before_validation :initialize_special_page, on: :create, if: :is_special_page?
  end

  # Communication::Website::Page::CommunicationPosts -> communication_posts
  # Used for i18n
  def type_key
    type.demodulize.underscore
  end

  def is_home?
    type == 'Communication::Website::Page::Home'
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

  def is_listed_among_children?
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

  # Some pages need a specific Hugo layout
  def static_layout
    nil
  end

  def default_menu_identifier
    'primary'
  end

  def generate_from_template
  end

  protected

  def default_parent
    website.special_page(Communication::Website::Page::Home, language: language)
  end

  def initialize_special_page
    i18n_key = "communication.website.pages.defaults.#{type_key}"
    self.title = I18n.t("#{i18n_key}.title")
    self.slug = I18n.t("#{i18n_key}.slug")
    self.parent = default_parent
    self.full_width = full_width_by_default?
    self.published = published_by_default?
  end

  def generate_heading(title)
    headings.create(university: university, title: title)
  end

  def generate_block(heading, kind, data)
    blocks.create(university: university, heading: heading, template_kind: kind, data: data.to_json)
  end

end
