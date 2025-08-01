# == Schema Information
#
# Table name: communication_websites
#
#  id                           :uuid             not null, primary key
#  about_type                   :string           indexed => [about_id]
#  access_token                 :string
#  archive_content              :boolean          default(FALSE)
#  autoupdate_theme             :boolean          default(TRUE)
#  default_time_zone            :string
#  deployment_status_badge      :text
#  deuxfleurs_hosting           :boolean          default(TRUE)
#  deuxfleurs_identifier        :string
#  deuxfleurs_secret_access_key :string
#  feature_agenda               :boolean          default(FALSE)
#  feature_alerts               :boolean          default(FALSE)
#  feature_alumni               :boolean          default(FALSE)
#  feature_hourly_publication   :boolean          default(FALSE)
#  feature_jobboard             :boolean          default(FALSE)
#  feature_portfolio            :boolean          default(FALSE)
#  feature_posts                :boolean          default(TRUE)
#  git_branch                   :string
#  git_endpoint                 :string
#  git_files_analysed_at        :datetime
#  git_provider                 :integer          default("github")
#  highlighted_in_showcase      :boolean          default(FALSE)
#  in_production                :boolean          default(FALSE)
#  in_showcase                  :boolean          default(TRUE)
#  last_sync_at                 :datetime
#  locked_at                    :datetime
#  plausible_url                :string
#  repository                   :string
#  style                        :text
#  style_updated_at             :date
#  theme_version                :string           default("NA")
#  url                          :string
#  years_before_archive_content :integer          default(3)
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
#  index_communication_websites_on_university_id        (university_id)
#
# Foreign Keys
#
#  fk_rails_2b6d929310  (default_language_id => languages.id)
#  fk_rails_bb6a496c08  (university_id => universities.id)
#
class Communication::Website < ApplicationRecord
  self.filter_attributes += [:access_token, :deuxfleurs_secret_access_key]

  include Favoritable
  include Filterable
  include GeneratesGitFiles
  include Localizable
  include LocalizableOrderByNameScope
  include Searchable
  include WithAbouts
  include WithAssociatedObjects
  include WithConfigs
  include WithConnectedObjects
  include WithContentArchive
  include WithDependencies
  include WithDeuxfleurs
  include WithFeatureAgenda
  include WithFeatureAlerts
  include WithFeatureAlumni
  include WithFeatureJobboard
  include WithFeaturePosts
  include WithFeaturePortfolio
  include WithFederations
  include WithGitRepository
  include WithLock
  include WithManagers
  include WithOpenApi
  include WithProgramCategories
  include WithSpecialPages
  include WithMenus # Menus must be created after special pages, so we can fill legal menu
  include WithScreenshot
  include WithSecurity
  include WithShowcase
  include WithStyle
  include WithTheme
  include WithTimeZone
  include WithUniversity

  enum :git_provider, {
    github: 0,
    gitlab: 1
  }

  belongs_to :default_language, class_name: "Language"

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
      .where(communication_website_localizations: { language_id: language.id })
      .where("
        unaccent(universities.name) ILIKE unaccent(:term) OR
        unaccent(communication_website_localizations.name) ILIKE unaccent(:term) OR
        unaccent(communication_websites.url) ILIKE unaccent(:term)
      ", term: "%#{sanitize_sql_like(term)}%")
  }
  scope :for_update, -> (autoupdate, language = nil) { where(autoupdate_theme: autoupdate) }
  scope :with_url, -> { where.not(url: [nil, '']) }
  scope :with_access_token, -> { where.not(access_token: [nil, '']) }
  scope :ordered_by_production_date, -> {
    # TODO add in_production_at and use it
    order(created_at: :desc)
  }

  def self.organized_for(user, language, limit: 6)
    university = user.university
    ability = ::Ability.for(user)
    # Favorites first
    favorites_ids = user.favorites.websites.pluck(:about_id)
    websites =  university.websites
                          .where(id: favorites_ids)
                          .accessible_by(ability)
                          .ordered(language)
                          .collect(&:website)
    # Then the rest
    if websites.count < limit
      remaining = limit - websites.count
      websites += university.websites
                            .where.not(id: favorites_ids)
                            .accessible_by(ability)
                            .ordered(language)
                            .limit(remaining)
                            .collect(&:website)
    end
    websites
  end

  def to_s
    original_localization.to_s
  end

  # TODO deprecated
  def git_path(website)
    "data/website.yml"
  end

  # TODO deprecated
  def can_have_git_file?
    true
  end

  # TODO deprecated
  def should_sync_to?(website)
    website.id == id
  end

  def dependencies
    # Le website est le SEUL cas d'auto-dépendance
    [self] +
    localizations.in_languages(active_language_ids) +
    configs +
    pages +
    page_categories +
    feature_agenda_dependencies +
    feature_alumni_dependencies +
    feature_jobboard_dependencies +
    feature_portfolio_dependencies +
    feature_posts_dependencies +
    feature_alerts_dependencies +
    menus.in_languages(active_language_ids) +
    [default_image&.blob] +
    [default_shared_image&.blob] +
    indirect_objects_connected_to_website
  end

  def indirect_objects_connected_to_website
    [about].compact +
    alumni +
    cohorts +
    academic_years +
    federated_objects
  end

  # Objets indirects connectés, avec toutes leurs dépendances récursives
  # Méthode utilisée pour vérifier les connexions obsolètes
  def indirect_objects_connected_to_website_recursive
    objects = indirect_objects_connected_to_website
    (
      objects +
      objects.collect(&:recursive_dependencies).flatten
    ).uniq
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

  def move_to_university(new_university_id)
    return if self.university_id == new_university_id
    update_column :university_id, new_university_id
    recursive_dependencies_following_direct.each do |dependency|
      reconnect_dependency dependency, new_university_id
    end
  end

  def domain
    URI.parse(url).host
  rescue URI::InvalidURIError
    ""
  end

  def domain_slug
    domain&.parameterize
  end

  protected

  def sanitize_fields
    self.git_branch = Osuny::Sanitizer.sanitize(self.git_branch, 'string')
    self.git_endpoint = Osuny::Sanitizer.sanitize(self.git_endpoint, 'string')
    self.plausible_url = Osuny::Sanitizer.sanitize(self.plausible_url, 'string')
    self.repository = Osuny::Sanitizer.sanitize(self.repository, 'string')
    self.url = Osuny::Sanitizer.sanitize(self.url, 'string')
  end

  def set_default_language
    self.default_language_id = self.localizations.first.language_id
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
