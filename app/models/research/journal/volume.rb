# == Schema Information
#
# Table name: research_journal_volumes
#
#  id                    :uuid             not null, primary key
#  featured_image_alt    :string
#  featured_image_credit :text
#  keywords              :text
#  meta_description      :text
#  number                :integer
#  published             :boolean          default(FALSE)
#  published_at          :datetime
#  slug                  :string
#  summary               :text
#  text                  :text
#  title                 :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  research_journal_id   :uuid             not null, indexed
#  university_id         :uuid             not null, indexed
#
# Indexes
#
#  index_research_journal_volumes_on_research_journal_id  (research_journal_id)
#  index_research_journal_volumes_on_university_id        (university_id)
#
# Foreign Keys
#
#  fk_rails_814e97604b  (research_journal_id => research_journals.id)
#  fk_rails_c83d5e9068  (university_id => universities.id)
#
class Research::Journal::Volume < ApplicationRecord
  include AsIndirectObject
  include Sanitizable
  include WithBlobs
  include WithFeaturedImage
  include WithGitFiles
  include WithPermalink
  include WithPublication
  include WithSlug
  include WithUniversity

  has_summernote :text

  belongs_to :journal, foreign_key: :research_journal_id
  has_many :papers, foreign_key: :research_journal_volume_id, dependent: :nullify
  has_many :communication_websites, -> { distinct }, through: :journal
  has_many :people, -> { distinct }, through: :papers

  scope :ordered, -> { order(number: :desc, published_at: :desc) }

  def git_path(website)
    "#{git_path_content_prefix(website)}volumes#{path}/_index.html" if published_at
  end

  def template_static
    "admin/research/journals/volumes/static"
  end

  def dependencies
    papers +
    people.map(&:researcher) +
    active_storage_blobs
  end

  def references
    []
  end

  def path
    "/#{published_at&.year}-#{slug}" if published_at
  end

  def to_s
    "#{ title }"
  end

  protected

  def explicit_blob_ids
    super.concat [featured_image&.blob_id]
  end

  def inherited_blob_ids
    [best_featured_image&.blob_id]
  end
end
