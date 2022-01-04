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

  belongs_to  :university

  scope :ordered, -> { order(:name) }

  def to_s
    "#{name}"
  end

  def list_of_categories
    all_categories = []
    categories.root.ordered.each do |category|
      all_categories.concat(category.self_and_children(0))
    end
    all_categories
  end

  def list_of_programs
    all_programs = []
    programs.root.ordered.each do |program|
      all_programs.concat(program.self_and_children(0))
    end
    all_programs
  end

  def git_path_static
    "data/website.yml"
  end

  def git_dependencies_static
    pages + posts + categories + menus + members + [home]
  end
end
