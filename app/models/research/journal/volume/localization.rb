# == Schema Information
#
# Table name: research_journal_volume_localizations
#
#  id                    :uuid             not null, primary key
#  deleted_at            :datetime
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
#  about_id              :uuid             uniquely indexed => [language_id], indexed
#  language_id           :uuid             uniquely indexed => [about_id], indexed
#  university_id         :uuid             indexed
#
# Indexes
#
#  idx_on_about_id_language_id_adf437eb06                        (about_id,language_id) UNIQUE
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
  acts_as_paranoid

  include AsLocalization
  include HasGitFiles
  include Initials
  include Permalinkable
  include Publishable
  include Sanitizable
  include WithBlobs
  include WithFeaturedImage
  include WithUniversity

  alias :volume :about

  delegate :number, to: :volume

  has_summernote :summary
  has_summernote :text

  validates :title, presence: true

  def git_path_relative
    "volumes/#{hugo_slug}/_index.html"
  end

  def should_sync_to?(website)
    website.active_language_ids.include?(language_id) &&
    website.has_connected_object?(self) &&
    published?
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

  def hugo_slug
    "#{published_at&.year}-#{slug}"
  end

  # Hugo a besoin d'un slug spécial parce que les volumes sont des catégories
  def hugo_slug_in_website(website)
    hugo_slug
  end
end
