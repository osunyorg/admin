# == Schema Information
#
# Table name: communication_websites
#
#  id            :uuid             not null, primary key
#  about_type    :string           indexed => [about_id]
#  access_token  :string
#  git_endpoint  :string
#  git_provider  :integer          default("github")
#  name          :string
#  repository    :string
#  url           :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  about_id      :uuid             indexed => [about_type]
#  university_id :uuid             not null, indexed
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
  include WithIndexPages
  include WithMenuItems
  include WithProgramCategories

  scope :ordered, -> { order(:name) }

  enum git_provider: {
    github: 0,
    gitlab: 1
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
    dependencies += posts + posts.map(&:active_storage_blobs).flatten if has_communication_posts?
    dependencies += people_with_facets + people.map(&:active_storage_blobs).flatten if has_people?
    dependencies += [categories] if has_communication_categories?
    dependencies += about.git_dependencies(website)

    # TMP: add index_pages
    dependencies += [index_for(:home)] + index_for(:home).active_storage_blobs
    dependencies += [index_for(:communication_posts)] + index_for(:communication_posts).active_storage_blobs if has_communication_posts?
    dependencies += [index_for(:education_programs)] + index_for(:education_programs).active_storage_blobs if has_education_programs?
    dependencies += [index_for(:persons)] + index_for(:persons).active_storage_blobs if has_people?
    dependencies += [index_for(:authors)] + index_for(:authors).active_storage_blobs if has_authors?
    dependencies += [index_for(:administrators)] + index_for(:administrators).active_storage_blobs if has_administrators?
    dependencies += [index_for(:teachers)] + index_for(:teachers).active_storage_blobs if has_teachers?
    dependencies += [index_for(:research_volumes)] + index_for(:research_volumes).active_storage_blobs if has_research_volumes?
    dependencies += [index_for(:research_articles)] + index_for(:research_articles).active_storage_blobs if has_research_articles?
    dependencies += [index_for(:researchers)] + index_for(:researchers).active_storage_blobs if has_researchers?
    # END TMP

    dependencies
  end

end
