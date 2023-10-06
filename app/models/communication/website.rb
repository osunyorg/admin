# == Schema Information
#
# Table name: communication_websites
#
#  id                      :uuid             not null, primary key
#  about_type              :string           indexed => [about_id]
#  access_token            :string
#  autoupdate_theme        :boolean          default(TRUE)
#  deployment_status_badge :text
#  deuxfleurs_hosting      :boolean          default(TRUE)
#  deuxfleurs_identifier   :string
#  feature_agenda          :boolean          default(FALSE)
#  feature_posts           :boolean          default(TRUE)
#  git_branch              :string
#  git_endpoint            :string
#  git_provider            :integer          default("github")
#  in_production           :boolean          default(FALSE)
#  name                    :string
#  plausible_url           :string
#  repository              :string
#  social_email            :string
#  social_facebook         :string
#  social_github           :string
#  social_instagram        :string
#  social_linkedin         :string
#  social_mastodon         :string
#  social_peertube         :string
#  social_tiktok           :string
#  social_vimeo            :string
#  social_x                :string
#  social_youtube          :string
#  style                   :text
#  style_updated_at        :date
#  theme_version           :string           default("NA")
#  url                     :string
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  about_id                :uuid             indexed => [about_type]
#  default_language_id     :uuid             not null, indexed
#  university_id           :uuid             not null, indexed
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

  include WithAbouts
  include WithAssociatedObjects
  include WithConfigs
  include WithConnectedObjects
  include WithDependencies
  include WithDeuxfleurs
  include WithGit
  include WithGitRepository
  include WithLanguages
  include WithManagers
  include WithProgramCategories
  include WithReferences
  include WithSpecialPages
  include WithMenus # Menus must be created after special pages, so we can fill legal menu
  include WithSecurity
  include WithStyle
  include WithTheme
  include WithUniversity

  enum git_provider: {
    github: 0,
    gitlab: 1
  }

  before_validation :sanitize_fields

  scope :ordered, -> { order(:name) }
  scope :in_production, -> { where(in_production: true) }
  scope :for_production, -> (production) { where(in_production: production) }
  scope :for_theme_version, -> (version) { where(theme_version: version) }
  scope :for_search_term, -> (term) {
    where("
      unaccent(communication_websites.name) ILIKE unaccent(:term) OR
      unaccent(communication_websites.url) ILIKE unaccent(:term)
    ", term: "%#{sanitize_sql_like(term)}%")
  }
  scope :for_update, -> (autoupdate) { where(autoupdate_theme: autoupdate) }
  scope :for_updatable_theme, -> (status) { updatable_theme if status == 'true' }
  scope :updatable_theme, -> {
    where.not(repository: [nil, '']).
    where.not(access_token: [nil, '']).
    where.not(url: [nil, ''])
  }

  def to_s
    "#{name}"
  end

  def git_path(website)
    "data/website.yml"
  end

  def dependencies
    # Le website est le SEUL cas d'auto-dépendance
    [self] +
    configs +
    pages.where(language_id: language_ids) +
    posts.where(language_id: language_ids) +
    events.where(language_id: language_ids) +
    categories.where(language_id: language_ids) +
    menus.where(language_id: language_ids) +
    [about]
  end

  def website
    self
  end

  def website_id
    id
  end

  # Override to follow direct objects
  def sync_with_git
    return unless website.git_repository.valid?
    if syncable?
      Communication::Website::GitFile.sync website, self
      recursive_dependencies(syncable_only: true, follow_direct: true).each do |object|
        Communication::Website::GitFile.sync website, object
      end
      references.each do |object|
        Communication::Website::GitFile.sync website, object
      end
    end
    website.git_repository.sync!
  end
  handle_asynchronously :sync_with_git, queue: 'default'

  protected

  def sanitize_fields
    self.git_branch = Osuny::Sanitizer.sanitize(self.git_branch, 'string')
    self.git_endpoint = Osuny::Sanitizer.sanitize(self.git_endpoint, 'string')
    self.name = Osuny::Sanitizer.sanitize(self.name, 'string')
    self.plausible_url = Osuny::Sanitizer.sanitize(self.plausible_url, 'string')
    self.repository = Osuny::Sanitizer.sanitize(self.repository, 'string')
    self.url = Osuny::Sanitizer.sanitize(self.url, 'string')
  end
end
