# == Schema Information
#
# Table name: communication_websites
#
#  id               :uuid             not null, primary key
#  about_type       :string           indexed => [about_id]
#  access_token     :string
#  git_branch       :string
#  git_endpoint     :string
#  git_provider     :integer          default("github")
#  in_production    :boolean          default(FALSE)
#  name             :string
#  plausible_url    :string
#  repository       :string
#  style            :text
#  style_updated_at :date
#  url              :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  about_id         :uuid             indexed => [about_type]
#  university_id    :uuid             not null, indexed
#
# Indexes
#
#  index_communication_websites_on_about          (about_type,about_id)
#  index_communication_websites_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_bb6a496c08  (university_id => universities.id)
#
class Communication::Website < ApplicationRecord
  include WithUniversity
  include WithAbouts
  include WithConfigs
  include WithDependencies
  include WithGit
  include WithGitRepository
  include WithImport
  include WithMenuItems
  include WithProgramCategories
  include WithSpecialPages
  include WithStyle

  enum git_provider: {
    github: 0,
    gitlab: 1
  }

  has_and_belongs_to_many :languages,
                          class_name: 'Language',
                          join_table: 'communication_websites_languages',
                          foreign_key: 'communication_website_id',
                          association_foreign_key: 'language_id'

  scope :ordered, -> { order(:name) }
  scope :in_production, -> { where(in_production: true) }
  scope :for_search_term, -> (term) {
    where("
      unaccent(communication_websites.name) ILIKE unaccent(:term) OR
      unaccent(communication_websites.url) ILIKE unaccent(:term)
    ", term: "%#{sanitize_sql_like(term)}%")
  }

  def to_s
    "#{name}"
  end

  def git_path(website)
    "data/website.yml"
  end

  def git_dependencies(website)
    dependencies = [self, config_permalinks, config_base_url] + menus
    dependencies += pages + pages.map(&:active_storage_blobs).flatten
    dependencies += posts + posts.map(&:active_storage_blobs).flatten
    dependencies += people_with_facets + people.map(&:active_storage_blobs).flatten
    dependencies += organizations_in_blocks + organizations_in_blocks.map(&:active_storage_blobs).flatten
    dependencies += categories
    dependencies += about.git_dependencies(website) if about.present?
    dependencies
  end
end
