# == Schema Information
#
# Table name: communication_website_permalinks
#
#  id            :uuid             not null, primary key
#  about_type    :string           indexed => [about_id]
#  is_current    :boolean          default(TRUE)
#  path          :string
#  target_url    :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  about_id      :uuid             indexed => [about_type]
#  university_id :uuid             not null, indexed
#  website_id    :uuid             not null, indexed
#
# Indexes
#
#  index_communication_website_permalinks_on_about          (about_type,about_id)
#  index_communication_website_permalinks_on_university_id  (university_id)
#  index_communication_website_permalinks_on_website_id     (website_id)
#
# Foreign Keys
#
#  fk_rails_e9646cce64  (university_id => universities.id)
#  fk_rails_f389ba7d45  (website_id => communication_websites.id)
#
class Communication::Website::Permalink < ApplicationRecord

  include Filterable
  include WithMapping
  include WithOpenApi
  # We don't include Sanitizable as this model is never handled by users directly.
  include WithUniversity

  belongs_to :university
  belongs_to :website, class_name: "Communication::Website"
  belongs_to :about, polymorphic: true, optional: true

  validates :path, presence: true
  validates :path, uniqueness: { scope: :website_id }, unless: :is_current
  # TODO: validate :root_path_is_reserved_for_home

  before_validation :set_university, on: :create
  # We should not sync the about object whenever we do something with the permalink, as they can be changed during a sync.
  # so we have an attribute accessor to force-sync the about, for example in the Permalinkable concern
  after_commit :touch_about, on: [:create, :destroy]
  after_commit :regenerate_website_hosting_config

  scope :for_website, -> (website) { where(website_id: website.id) }
  scope :current, -> { where(is_current: true) }
  scope :not_current, -> { where(is_current: false) }
  scope :not_root, -> { where.not(path: '/') }
  scope :internal, -> { where.not(about_id: nil) }
  scope :external, -> { where(about_id: nil) }
  scope :ordered, -> { order(:path) }

  # Filters
  scope :for_search_term, -> (term, language) {
    where("communication_website_permalinks.path LIKE :term", term: "%#{sanitize_sql_like(term)}%")
  }
  scope :for_type, -> (type, language) {
    type == 'internal' ? internal : external
  }

  def self.config_in_website(website, language)
    required_kinds_in_website(website).map { |permalink_class|
      [
        permalink_class.static_config_key,
        permalink_class.pattern_in_website(website, language)
      ]
    }.to_h
  end

  # Can be overwritten
  def self.required_in_config?(website)
    false
  end

  # Should be defined in subclasses
  # Not protected because it is used in the website config "DefaultLanguages"
  def self.pattern_in_website(website, language, about = nil)
    raise NoMethodError
  end

  # Méthode pour accéder facilement à la page spéciale,
  # qui s'appuie sur le `special_page_type` de chaque Permalink
  def self.special_page(website)
    website.special_page(self.special_page_type)
  end

  # Méthode d'utilité pour récupérer le slug d'une page spéciale avec ses ancêtres
  def self.special_page_path(website, language)
    special_page = self.special_page(website)
    return '' if special_page.nil?
    page_l10n = special_page.localization_for(language)
    return '' if page_l10n.nil?
    '/' + page_l10n.slug_with_ancestors_slugs
  end

  # Doit être surchargé dans les classes par type, comme `Communication::Website::Permalink::Post`
  def self.special_page_type
    raise NoMethodError
  end

  def pattern
    language = about.respond_to?(:language) ? about.language : website.default_language
    self.class.pattern_in_website(website, language, about)
  end

  def computed_path
    unless @computed_path
      path = ""
      path += "/#{language.iso_code}" if website.active_languages.many?
      path += pattern
      substitutions.each do |key, value|
        path.gsub! ":#{key}", "#{value}"
      end
      path
      @computed_path = Static.clean_path(path)
    end
    @computed_path
  end

  def save_if_needed
    current_permalink = about.current_permalink_in_website(website)

    return unless computed_path.present? && (current_permalink.nil? || current_permalink.path != computed_path)

    # If the object had no permalink or if its path changed, we create a new permalink and delete website redirections with the same path
    existing_permalinks_for_path = self.class.unscoped.where(website_id: website_id, path: computed_path, is_current: false)
    self.path = computed_path
    if save
      existing_permalinks_for_path.find_each(&:destroy)
      current_permalink&.update(is_current: false)
    end
  end

  def special_page(website)
    self.class.special_page(website)
  end

  # Starting from Hugo 0.155, aliases are site-relative,
  # so we need to go one level up on multilingual sites to get the correct path.
  # More info: https://developers.osuny.org/docs/theme/architecture/aliases/
  def alias_path
    "/..#{path}"
  end

  def external?
    about.nil?
  end

  def internal?
    about.present?
  end

  def target
    internal? ? about.current_permalink_in_website(website) : target_url
  end

  def to_s
    "#{path}"
  end

  protected

  def language
    @language ||= about.respond_to?(:language) ? about.language : website.default_language
  end

  # Can be overwritten
  def substitutions
    {
      slug: about.slug
    }
  end

  def set_university
    self.university_id = website.university_id
  end

  def touch_about
    return unless about.present? && about.persisted?
    about.touch
  end

  def regenerate_website_hosting_config
    return unless website.persisted?
    website.regenerate_hosting_config!
  end

  def root_path_is_reserved_for_home
    return unless path == "/"
    errors.add(:path, :reserved_for_home) unless about.about.is_a?(Communication::Website::Page::Home)
  end
end
