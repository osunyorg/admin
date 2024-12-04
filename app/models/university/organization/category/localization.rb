# == Schema Information
#
# Table name: university_organization_category_localizations
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
#  idx_on_about_id_f5fce0a0b7                                    (about_id)
#  idx_on_language_id_8e479f2339                                 (language_id)
#  idx_on_university_id_2aaf668550                               (university_id)
#  index_university_organization_category_localizations_on_slug  (slug)
#
# Foreign Keys
#
#  fk_rails_72f43eab36  (about_id => university_organization_categories.id)
#  fk_rails_d162c90661  (university_id => universities.id)
#  fk_rails_dca0802d2f  (language_id => languages.id)
#
class University::Organization::Category::Localization < ApplicationRecord
  include AsCategoryLocalization

  def git_path(website)
    return unless for_website?(website)
    prefix = git_path_content_prefix(website)
    "#{prefix}organizations_categories/#{slug_with_ancestors_slugs}/_index.html"
  end

  def published?
    persisted?
  end
end
