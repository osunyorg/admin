# == Schema Information
#
# Table name: communication_websites
#
#  id                           :uuid             not null, primary key
#  about_type                   :string           indexed => [about_id]
#  access_token                 :string
#  autoupdate_theme             :boolean          default(TRUE)
#  default_time_zone            :string
#  deployment_status_badge      :text
#  deuxfleurs_hosting           :boolean          default(TRUE)
#  deuxfleurs_identifier        :string
#  deuxfleurs_secret_access_key :string
#  feature_agenda               :boolean          default(FALSE)
#  feature_portfolio            :boolean          default(FALSE)
#  feature_posts                :boolean          default(TRUE)
#  git_branch                   :string
#  git_endpoint                 :string
#  git_files_analysed_at        :datetime
#  git_provider                 :integer          default("github")
#  highlighted_in_showcase      :boolean          default(FALSE)
#  in_production                :boolean          default(FALSE)
#  in_showcase                  :boolean          default(TRUE)
#  locked_at                    :datetime
#  name                         :string           indexed
#  plausible_url                :string
#  repository                   :string
#  social_email                 :string
#  social_facebook              :string
#  social_github                :string
#  social_instagram             :string
#  social_linkedin              :string
#  social_mastodon              :string
#  social_peertube              :string
#  social_tiktok                :string
#  social_vimeo                 :string
#  social_x                     :string
#  social_youtube               :string
#  style                        :text
#  style_updated_at             :date
#  theme_version                :string           default("NA")
#  url                          :string
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#  about_id                     :uuid             indexed => [about_type]
#  default_language_id          :uuid             not null, indexed
#  deuxfleurs_access_key_id     :string
#  locked_by_job_id             :uuid
#  university_id                :uuid             not null, indexed
#
# Indexes
#
#  index_communication_websites_on_about                (about_type,about_id)
#  index_communication_websites_on_default_language_id  (default_language_id)
#  index_communication_websites_on_name                 (name) USING gin
#  index_communication_websites_on_university_id        (university_id)
#
# Foreign Keys
#
#  fk_rails_2b6d929310  (default_language_id => languages.id)
#  fk_rails_bb6a496c08  (university_id => universities.id)
#
class Communication::Website < ApplicationRecord
  self.filter_attributes += [:access_token]

  include Favoritable
  include Filterable
  include Localizable
  include LocalizableOrderByNameScope
  include WithAbouts
  include WithAssociatedObjects
  include WithConfigs
  include WithConnectedObjects
  include WithDependencies
  include WithDeuxfleurs
  include WithFeatureAgenda
  include WithFeaturePosts
  include WithFeaturePortfolio
  include WithGit
  include WithGitRepository
  include WithLock
  include WithManagers
  include WithProgramCategories
  include WithReferences
  include WithSpecialPages
  include WithMenus # Menus must be created after special pages, so we can fill legal menu
  include WithScreenshot
  include WithSecurity
  include WithShowcase
  include WithStyle
  include WithTheme
  include WithUniversity

  enum git_provider: {
    github: 0,
    gitlab: 1
  }

  belongs_to :default_language, class_name: "Language"

  # TODO L10N : remove after migrations
  has_and_belongs_to_many :legacy_languages,
                          class_name: "Language",
                          join_table: :communication_websites_languages,
                          foreign_key: :communication_website_id,
                          association_foreign_key: :language_id
  has_many :languages, through: :localizations
  has_many  :active_languages,
            -> { where(communication_website_localizations: { published: true }) },
            through: :localizations,
            source: :language

  has_one_attached_deletable :default_image
  has_one_attached_deletable :default_shared_image

  validates :default_image, size: { less_than: 5.megabytes }
  validates :default_shared_image, size: { less_than: 5.megabytes }

  before_validation :sanitize_fields
  before_validation :set_default_language,
                    :set_first_localization_as_published,
                    on: :create

  scope :in_production, -> { where(in_production: true) }
  scope :for_production, -> (production, language = nil) { where(in_production: production) }
  scope :for_search_term, -> (term, language) {
    joins(:university)
      .joins(:localizations)
      .where("
        unaccent(universities.name) % unaccent(:term) OR
        unaccent(communication_website_localizations.name) % unaccent(:term) OR
        unaccent(communication_websites.url) % unaccent(:term)
      ", term: "%#{sanitize_sql_like(term)}%")
  }
  scope :for_update, -> (autoupdate) { where(autoupdate_theme: autoupdate) }
  scope :with_url, -> { where.not(url: [nil, '']) }
  scope :with_access_token, -> { where.not(access_token: [nil, '']) }

  def to_s
    "#{name}"
  end

  def git_path(website)
    "data/website.yml"
  end

  def dependencies
    # Le website est le SEUL cas d'auto-dépendance
    [self] +
    localizations.in_languages(active_language_ids) +
    configs +
    pages +
    posts +
    post_categories +
    events +
    agenda_categories +
    projects +
    portfolio_categories +
    menus.in_languages(active_language_ids) +
    [about] +
    [default_image&.blob] +
    [default_shared_image&.blob]
  end

  def website
    self
  end

  def websites
    [self]
  end

  def website_id
    id
  end

  # Override to follow direct objects
  def sync_with_git
    Communication::Website::SyncWithGitJob.perform_later(id)
  end

  # Appelé en asynchrone par Communication::Website::SyncWithGitJob
  def sync_with_git_safely
    return unless should_sync_with_git?
    Communication::Website::GitFile.sync website, self
    recursive_dependencies(syncable_only: true, follow_direct: true).each do |object|
      Communication::Website::GitFile.sync website, object
    end
    git_repository.sync!
  end

  def move_to_university(new_university_id)
    return if self.university_id == new_university_id
    update_column :university_id, new_university_id
    recursive_dependencies_syncable_following_direct.each do |dependency|
      reconnect_dependency dependency, new_university_id
    end
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

  def set_default_language
    self.default_language_id = self.localizations.first.language_id
  end

  def set_first_localization_as_published
    localizations.first.assign_attributes(
      published: true,
      published_at: Time.zone.now
    )
  end

  def reconnect_dependency(dependency, new_university_id)
    # puts
    # puts "reconnect dependency #{dependency} - #{dependency.class}"
    unless dependency.respond_to?(:university_id)
      # puts "no university"
      return
    end
    # puts "  respond to university_id"
    # vérifier par les connexions qu'un objet indirect n'est pas utilisé dans un autre website
    if dependency.respond_to?(:connections) && dependency.connections.where.not(website: self).any?
      # puts "other connection found, not moving"
      return
    end
    # puts "  no other connection"
    # il faut si l'objet est une person déconnecter le user éventuellement associé.
    if dependency.is_a? University::Person
      # puts "person, disconnecting from user"
      dependency.update_column :user_id, nil
    end
    # puts "connecting to #{new_university_id}"
    dependency.update_column :university_id, new_university_id
  end
end
