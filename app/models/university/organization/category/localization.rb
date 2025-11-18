# == Schema Information
#
# Table name: university_organization_category_localizations
#
#  id                    :uuid             not null, primary key
#  breadcrumb_title      :string
#  featured_image_alt    :text
#  featured_image_credit :text
#  header_cta            :boolean          default(FALSE)
#  header_cta_label      :string
#  header_cta_url        :string
#  header_text           :text
#  meta_description      :text
#  migration_identifier  :string
#  name                  :string
#  slug                  :string           indexed
#  subtitle              :string
#  summary               :text
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  about_id              :uuid             indexed, uniquely indexed => [language_id]
#  language_id           :uuid             uniquely indexed => [about_id], indexed
#  university_id         :uuid             indexed
#
# Indexes
#
#  idx_on_about_id_f5fce0a0b7                                    (about_id)
#  idx_on_about_id_language_id_a3c481c2fd                        (about_id,language_id) UNIQUE
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
  include WithOpenApi

  def git_path_relative
    "organizations_categories/#{slug_with_ancestors_slugs}/_index.html"
  end

end
