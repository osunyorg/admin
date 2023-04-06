# == Schema Information
#
# Table name: communication_websites
#
#  id                  :uuid             not null, primary key
#  about_type          :string           indexed => [about_id]
#  access_token        :string
#  git_branch          :string
#  git_endpoint        :string
#  git_provider        :integer          default("github")
#  in_production       :boolean          default(FALSE)
#  name                :string
#  plausible_url       :string
#  repository          :string
#  style               :text
#  style_updated_at    :date
#  theme_version       :string           default("NA")
#  url                 :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  about_id            :uuid             indexed => [about_type]
#  default_language_id :uuid             not null, indexed
#  university_id       :uuid             not null, indexed
#
# Indexes
#
#  index_communication_websites_on_about                (about_type,about_id)
#  index_communication_websites_on_default_language_id  (default_language_id)
#  index_communication_websites_on_university_id        (university_id)
#
# Foreign Keys
#
#  fk_rails_2b6d929310  (default_language_id => languages.id)
#  fk_rails_bb6a496c08  (university_id => universities.id)
#
class Communication::Website < ApplicationRecord
  self.filter_attributes += [:access_token]

  include WithUniversity
  include WithAbouts
  include WithConfigs
  include WithConnectedObjects
  include WithOldDependencies
  include WithGit
  include WithGitRepository
  include WithImport
  include WithProgramCategories
  include WithSpecialPages
  include WithMenus # Menus must be created after special pages, so we can fill legal menu
  include WithStyle
  include WithTheme

  enum git_provider: {
    github: 0,
    gitlab: 1
  }

  belongs_to :default_language, class_name: "Language"
  has_and_belongs_to_many :languages,
                          class_name: 'Language',
                          join_table: 'communication_websites_languages',
                          foreign_key: 'communication_website_id',
                          association_foreign_key: 'language_id'

  validates :languages, length: { minimum: 1 }
  validate :languages_must_include_default_language

  before_validation :sanitize_fields

  scope :ordered, -> { order(:name) }
  scope :in_production, -> { where(in_production: true) }
  scope :for_theme_version, -> (version) { where(theme_version: version) }
  scope :for_search_term, -> (term) {
    where("
      unaccent(communication_websites.name) ILIKE unaccent(:term) OR
      unaccent(communication_websites.url) ILIKE unaccent(:term)
    ", term: "%#{sanitize_sql_like(term)}%")
  }

  def self.save_and_sync_websites!
    find_each &:save_and_sync
  end

  def to_s
    "#{name}"
  end

  def git_path(website)
    "data/website.yml"
  end

  def dependencies
    pages +
    posts +
    categories +
    menus +
    [about]
  end

  def references
    []
  end

  def best_language_for(iso_code)
    # We look for the language by the ISO code in the websites languages.
    # If not found, we fallback to the default language.
    languages.find_by(iso_code: iso_code) || default_language
  end

  def website
    self
  end

  def website_id
    id
  end

  protected

  def sanitize_fields
    self.git_branch = Osuny::Sanitizer.sanitize(self.git_branch, 'string')
    self.git_endpoint = Osuny::Sanitizer.sanitize(self.git_endpoint, 'string')
    self.name = Osuny::Sanitizer.sanitize(self.name, 'string')
    self.plausible_url = Osuny::Sanitizer.sanitize(self.plausible_url, 'string')
    self.repository = Osuny::Sanitizer.sanitize(self.repository, 'string')
    self.url = Osuny::Sanitizer.sanitize(self.url, 'string')
  end

  def languages_must_include_default_language
    errors.add(:languages, :must_include_default) unless language_ids.include?(default_language_id)
  end
end
