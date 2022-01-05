# == Schema Information
#
# Table name: communication_websites
#
#  id                        :uuid             not null, primary key
#  about_type                :string
#  access_token              :string
#  authors_github_directory  :string           default("authors")
#  name                      :string
#  posts_github_directory    :string           default("posts")
#  programs_github_directory :string           default("programs")
#  repository                :string
#  staff_github_directory    :string           default("staff")
#  url                       :string
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  about_id                  :uuid
#  university_id             :uuid             not null
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
  include WithGitRepository
  include WithGit
  include WithHome
  include WithAbouts
  include WithImport

  belongs_to :university

  scope :ordered, -> { order(:name) }

  def to_s
    "#{name}"
  end

  def git_path_static
    "data/website.yml"
  end

  def git_dependencies_static
    (
      pages + pages.map(&:explicit_active_storage_blobs) +
      posts + posts.map(&:explicit_active_storage_blobs) +
      categories + menus + people +
      [home] + home.explicit_active_storage_blobs +
      [about]
    ).uniq.compact
  end
end
