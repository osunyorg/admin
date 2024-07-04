# == Schema Information
#
# Table name: communication_website_permalinks
#
#  id            :uuid             not null, primary key
#  about_type    :string           not null, indexed => [about_id]
#  is_current    :boolean          default(TRUE)
#  path          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  about_id      :uuid             not null, indexed => [about_type]
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
  attr_accessor :force_sync_about

  include WithMapping
  # We don't include Sanitizable as this model is never handled by users directly.
  include WithUniversity

  belongs_to :university
  belongs_to :website, class_name: "Communication::Website"
  belongs_to :about, polymorphic: true

  validates :about_id, :about_type, :path, presence: true

  before_validation :set_university, on: :create
  # We should not sync the about object whenever we do something with the permalink, as they can be changed during a sync.
  # so we have an attribute accessor to force-sync the about, for example in the Permalinkable concern
  after_commit :sync_about, on: [:create, :destroy], if: :force_sync_about

  scope :for_website, -> (website) { where(website_id: website.id) }
  scope :current, -> { where(is_current: true) }
  scope :not_current, -> { where(is_current: false) }
  scope :not_root, -> { where.not(path: '/') }

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

  def self.pattern_in_website(website, language)
    raise NotImplementedError
  end

  def self.clean_path(path)
    clean_path = path.dup
    # Remove eventual host
    clean_path = URI(clean_path).path
    # Leading slash for absolute path
    clean_path = "/#{clean_path}" unless clean_path.start_with?('/')
    # Trailing slash for coherence
    clean_path = "#{clean_path}/" unless clean_path.end_with?('/')
    clean_path
  rescue URI::InvalidURIError
    nil
  end

  # Méthode pour accéder facilement à la page spéciale,
  # qui s'appuie sur le `special_page_type` de chaque Permalink
  def self.special_page(website, language)
    website.special_page(self.special_page_type, language: language)
  end

  # Méthode d'utilité pour récupérer le slug
  def self.slug_with_ancestors(website, language)
    self.special_page(website, language).slug_with_ancestors
  end

  # Doit être surchargé dans les classes par type, comme `Communication::Website::Permalink::Post`
  def self.special_page_type
    raise NoMethodError
  end

  def pattern
    language = about.respond_to?(:language) ? about.language : website.default_language
    self.class.pattern_in_website(website, language)
  end

  def computed_path
    return @computed_path if defined?(@computed_path)
    @computed_path ||= published? ? Static.clean_path(published_path) : nil
  end

  def save_if_needed
    current_permalink = about.current_permalink_in_website(website)

    return unless computed_path.present? && (current_permalink.nil? || current_permalink.path != computed_path)

    # If the object had no permalink or if its path changed, we create a new permalink and delete old with same path
    existing_permalinks_for_path = self.class.unscoped.where(website_id: website_id, about_id: about_id, about_type: about_type, path: computed_path, is_current: false)
    self.path = computed_path
    if save
      existing_permalinks_for_path.find_each(&:destroy)
      current_permalink&.update(is_current: false)
    end
  end

  def special_page(website, language)
    self.class.special_page(website, language)
  end

  def to_s
    "#{path}"
  end

  protected

  # Can be overwritten (Page for example)
  def published_path
    # TODO I18n doit prendre la langue du about
    language = about.respond_to?(:language) ? about.language : website.default_language
    p = ""
    p += "/#{language.iso_code}" if website.languages.many?
    p += pattern
    substitutions.each do |key, value|
      p.gsub! ":#{key}", "#{value}"
    end
    p
  end

  # Can be overwritten
  def published?
    # TODO probleme si pas for_website?, par exemple pour les objets directs
    about.for_website?(website)
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

  def sync_about
    return unless about.persisted?
    about.is_direct_object? ? about.sync_with_git : about.touch
  end
end
