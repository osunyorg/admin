# == Schema Information
#
# Table name: education_school_localizations
#
#  id               :uuid             not null, primary key
#  meta_description :string
#  name             :string
#  published        :boolean          default(FALSE)
#  published_at     :datetime
#  slug             :string
#  summary          :text
#  url              :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  about_id         :uuid             indexed
#  language_id      :uuid             indexed
#  university_id    :uuid             indexed
#
# Indexes
#
#  index_education_school_localizations_on_about_id       (about_id)
#  index_education_school_localizations_on_language_id    (language_id)
#  index_education_school_localizations_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_5f0e85c2be  (language_id => languages.id)
#  fk_rails_62646f1456  (about_id => education_schools.id)
#  fk_rails_ef497f2390  (university_id => universities.id)
#
class Education::School::Localization < ApplicationRecord
  include AsLocalization
  include Contentful
  include Initials
  include Permalinkable
  include Sanitizable
  include WithAccessibility
  include WithGitFiles
  include WithPublication
  include WithUniversity

  has_one_attached_deletable :logo

  validates_presence_of :name
  validates :logo, size: { less_than: 1.megabytes }

  def git_path(website)
    "data/school.yml"
  end

  def template_static
    "admin/education/schools/static"
  end

  def dependencies
    active_storage_blobs +
    contents_dependencies
  end

  def to_s
    "#{name}"
  end

  protected

  def explicit_blob_ids
    [
      logo&.blob_id
    ]
  end

  def check_accessibility
    accessibility_merge_array blocks
  end
end
