# == Schema Information
#
# Table name: communication_websites
#
#  id                                :uuid             not null, primary key
#  about_type                        :string
#  access_token                      :string
#  name                              :string
#  repository                        :string
#  static_pathname_administrators    :string           default("administrators")
#  static_pathname_authors           :string           default("authors")
#  static_pathname_posts             :string           default("posts")
#  static_pathname_programs          :string           default("programs")
#  static_pathname_research_articles :string           default("articles")
#  static_pathname_research_volumes  :string           default("volumes")
#  static_pathname_researchers       :string           default("researchers")
#  static_pathname_staff             :string           default("staff")
#  static_pathname_teachers          :string           default("teachers")
#  url                               :string
#  created_at                        :datetime         not null
#  updated_at                        :datetime         not null
#  about_id                          :uuid
#  university_id                     :uuid             not null
#
# Indexes
#
#  index_communication_websites_on_about          (about_type,about_id)
#  index_communication_websites_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_...  (university_id => universities.id)
#
class Communication::Website < ApplicationRecord
  include WithAbouts
  include WithGit
  include WithGitRepository
  include WithHome
  include WithImport
  include WithMenuItems

  belongs_to :university

  scope :ordered, -> { order(:name) }

  def to_s
    "#{name}"
  end

  def git_path(website)
    "data/website.yml"
  end

  def git_dependencies(website)
    dependencies = (
      [self] +
      pages + pages.map(&:active_storage_blobs).flatten +
      posts + posts.map(&:active_storage_blobs).flatten +
      [home] + home.explicit_active_storage_blobs +
      categories + menus + people + [about]
    )

    if about.is_a? Education::School
      dependencies += about.programs
    elsif about.is_a? Research::Journal
      dependencies.concat [about.articles, about.volumes]
    end

    dependencies
  end
end
