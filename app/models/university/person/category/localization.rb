# == Schema Information
#
# Table name: university_person_category_localizations
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
#  name                  :string
#  slug                  :string           indexed
#  subtitle              :string
#  summary               :text
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  about_id              :uuid             uniquely indexed => [language_id], indexed
#  language_id           :uuid             uniquely indexed => [about_id], indexed
#  university_id         :uuid             indexed
#
# Indexes
#
#  idx_on_about_id_language_id_6784c3101c                         (about_id,language_id) UNIQUE
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
  include AsCategoryLocalization

  def git_path_relative
    "persons_categories/#{slug_with_ancestors_slugs}/_index.html"
  end

end
