# == Schema Information
#
# Table name: university_person_category_localizations
#
#  id                    :uuid             not null, primary key
#  featured_image_alt    :text
#  featured_image_credit :text
#  meta_description      :text
#  name                  :string
#  slug                  :string           indexed
#  summary               :text
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  about_id              :uuid             indexed
#  language_id           :uuid             indexed
#  university_id         :uuid             indexed
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
  include AsLocalizedTree
  include Contentful
  include Initials
  include Permalinkable
  include Sanitizable
  include WithFeaturedImage
  include WithGitFiles
  include WithUniversity

  validates :name, presence: true

  def dependencies
    contents_dependencies
  end

  def git_path(website)
    return unless for_website?(website)
    prefix = git_path_content_prefix(website)
    slugs = slug_with_ancestors_slugs(separator: '-')
    "#{prefix}persons_categories/#{slugs}/_index.html"
  end

  def template_static
    "admin/application/categories/static"
  end

  def to_s
    "#{name}"
  end

  def published?
    persisted?
  end

  # TODO : Pertinent ?
  def hugo_slug_in_website(website)
    slug_with_ancestors_slugs(separator: '-')
  end

end
