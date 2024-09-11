# == Schema Information
#
# Table name: education_program_category_localizations
#
#  id            :uuid             not null, primary key
#  name          :string
#  slug          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  about_id      :uuid             indexed
#  language_id   :uuid             indexed
#  university_id :uuid             indexed
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
  include AsLocalization
  include Contentful
  include Initials
  include Permalinkable
  include Sanitizable
  include WithGitFiles
  include WithUniversity

  validates :name, presence: true

  def git_path(website)
    "#{git_path_content_prefix(website)}programs_categories/#{slug}/_index.html"
  end

  def template_static
    "admin/education/programs/categories/static"
  end

  def dependencies
    contents_dependencies
  end

  def to_s
    "#{name}"
  end

  protected

  def slug_unavailable?(slug)
    self.class
        .unscoped
        .where(
          university_id: self.university_id,
          language_id: language_id,
          slug: slug
        )
        .where.not(id: self.id)
        .exists?
  end
end
