# == Schema Information
#
# Table name: education_diploma_localizations
#
#  id            :uuid             not null, primary key
#  duration      :text
#  name          :string
#  published     :boolean          default(FALSE)
#  published_at  :datetime
#  short_name    :string
#  slug          :string
#  summary       :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  about_id      :uuid             indexed
#  language_id   :uuid             indexed
#  university_id :uuid             indexed
#
# Indexes
#
#  index_education_diploma_localizations_on_about_id       (about_id)
#  index_education_diploma_localizations_on_language_id    (language_id)
#  index_education_diploma_localizations_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_20d7e63113  (about_id => education_diplomas.id)
#  fk_rails_e2ab6b2bb9  (language_id => languages.id)
#  fk_rails_e96c95a9cd  (university_id => universities.id)
#
class Education::Diploma::Localization < ApplicationRecord
  include AsLocalization
  include Backlinkable
  include Contentful
  include Initials
  include Permalinkable
  include Sanitizable
  include Shareable
  include WithGitFiles
  include WithPublication
  include WithUniversity

  has_summernote :summary

  validates :name, presence: true
  validates :name, uniqueness: { scope: :university_id }

  def dependencies
    contents_dependencies +
    active_storage_blobs
  end

  def git_path(website)
    "#{git_path_content_prefix(website)}diplomas/#{slug}/_index.html" if for_website?(website)
  end

  def template_static
    "admin/education/diplomas/static"
  end

  def to_s
    "#{name}"
  end

  def dependencies
    blocks
  end

  def references
    programs
  end

  def programs
    @programs ||=  about.programs
                        .ordered
                        .map { |program| program.localization_for(language) }
                        .compact
  end

  protected

  def check_accessibility
    accessibility_merge_array blocks
  end

  def backlinks_blocks(website)
    website.blocks.diplomas
  end

end
