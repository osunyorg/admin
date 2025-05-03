# == Schema Information
#
# Table name: education_program_category_localizations
#
#  id                    :uuid             not null, primary key
#  featured_image_alt    :text
#  featured_image_credit :text
#  meta_description      :text
#  name                  :string
#  slug                  :string
#  summary               :text
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  about_id              :uuid             indexed
#  language_id           :uuid             indexed
#  university_id         :uuid             indexed
#
# Indexes
#
#  idx_on_university_id_833fd3c673                                (university_id)
#  index_education_program_category_localizations_on_about_id     (about_id)
#  index_education_program_category_localizations_on_language_id  (language_id)
#
# Foreign Keys
#
#  fk_rails_00cd45d2d3  (university_id => universities.id)
#  fk_rails_f2b3e230b9  (about_id => education_program_categories.id)
#  fk_rails_fee1ce58f8  (language_id => languages.id)
#
class Education::Program::Category::Localization < ApplicationRecord
  include AsCategoryLocalization
  include AsIndirectObject

  def git_path(website)
    return unless for_website?(website)
    prefix = git_path_content_prefix(website)
    "#{prefix}programs_categories/#{slug_with_ancestors_slugs}/_index.html"
  end
end
