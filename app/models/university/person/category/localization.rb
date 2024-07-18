# == Schema Information
#
# Table name: university_person_category_localizations
#
#  id            :uuid             not null, primary key
#  name          :string
#  slug          :string           indexed
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  about_id      :uuid             indexed
#  language_id   :uuid             indexed
#  university_id :uuid             indexed
#
# Indexes
#
#  idx_on_university_id_1d7978113b                                (university_id)
#  index_university_person_category_localizations_on_about_id     (about_id)
#  index_university_person_category_localizations_on_language_id  (language_id)
#  index_university_person_category_localizations_on_slug         (slug)
#
# Foreign Keys
#
#  fk_rails_28a6f83b3f  (about_id => university_person_categories.id)
#  fk_rails_3b03de4967  (language_id => languages.id)
#  fk_rails_fdc0d1834b  (university_id => universities.id)
#
class University::Person::Category::Localization < ApplicationRecord
  include AsLocalization
  include Contentful
  include Initials
  include Permalinkable
  include Sanitizable
  include Sluggable
  include WithGitFiles
  include WithUniversity

  validates :name, presence: true

  def dependencies
    contents_dependencies
  end

  def git_path(website)
    "#{git_path_content_prefix(website)}persons_categories/#{slug}/_index.html" if for_website?(website)
  end

  def template_static
    "admin/university/people/categories/static"
  end

  def to_s
    "#{name}"
  end

  def published?
    persisted?
  end

end
