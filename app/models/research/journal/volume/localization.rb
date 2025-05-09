# == Schema Information
#
# Table name: research_journal_volume_localizations
#
#  id                    :uuid             not null, primary key
#  featured_image_alt    :string
#  featured_image_credit :text
#  keywords              :text
#  meta_description      :text
#  published             :boolean          default(FALSE)
#  published_at          :datetime
#  slug                  :string
#  summary               :text
#  text                  :text
#  title                 :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  about_id              :uuid             indexed
#  language_id           :uuid             indexed
#  university_id         :uuid             indexed
#
# Indexes
#
#  index_research_journal_volume_localizations_on_about_id       (about_id)
#  index_research_journal_volume_localizations_on_language_id    (language_id)
#  index_research_journal_volume_localizations_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_09d13500b6  (university_id => universities.id)
#  fk_rails_1e53ec2dc5  (language_id => languages.id)
#  fk_rails_f071a0b35b  (about_id => research_journal_volumes.id)
#
class Research::Journal::Volume::Localization < ApplicationRecord
  include AsLocalization
  include HasGitFiles
  include Initials
  include Permalinkable
  include Sanitizable
  include WithBlobs
  include WithFeaturedImage
  include WithPublication
  include WithUniversity

  alias :volume :about

  delegate :number, to: :volume

  has_summernote :summary
  has_summernote :text

  validates :title, presence: true

  def git_path(website)
    "#{git_path_content_prefix(website)}volumes/#{relative_path}/_index.html" if published?
  end

  def relative_path
    "#{published_at&.year}-#{slug}"
  end

  def template_static
    "admin/research/journals/volumes/static"
  end

  def dependencies
    active_storage_blobs
  end

  def to_s
    "#{title}"
  end

  protected

  def explicit_blob_ids
    super.concat [featured_image&.blob_id]
  end

  def inherited_blob_ids
    [best_featured_image&.blob_id]
  end
end
