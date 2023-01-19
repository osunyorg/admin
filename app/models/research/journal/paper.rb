# == Schema Information
#
# Table name: research_journal_papers
#
#  id                         :uuid             not null, primary key
#  abstract                   :text
#  keywords                   :text
#  meta_description           :text
#  position                   :integer
#  published                  :boolean          default(FALSE)
#  published_at               :datetime
#  references                 :text
#  slug                       :string
#  summary                    :text
#  text                       :text
#  title                      :string
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  paper_kind_id              :uuid             indexed
#  research_journal_id        :uuid             not null, indexed
#  research_journal_volume_id :uuid             indexed
#  university_id              :uuid             not null, indexed
#  updated_by_id              :uuid             indexed
#
# Indexes
#
#  index_research_journal_papers_on_paper_kind_id               (paper_kind_id)
#  index_research_journal_papers_on_research_journal_id         (research_journal_id)
#  index_research_journal_papers_on_research_journal_volume_id  (research_journal_volume_id)
#  index_research_journal_papers_on_university_id               (university_id)
#  index_research_journal_papers_on_updated_by_id               (updated_by_id)
#
# Foreign Keys
#
#  fk_rails_05213f4f24  (research_journal_id => research_journals.id)
#  fk_rails_22f161a6a7  (research_journal_volume_id => research_journal_volumes.id)
#  fk_rails_2713063b85  (updated_by_id => users.id)
#  fk_rails_935541e014  (university_id => universities.id)
#  fk_rails_db4e38788c  (paper_kind_id => research_journal_paper_kinds.id)
#
class Research::Journal::Paper < ApplicationRecord
  include Sanitizable
  include WithUniversity
  include WithGit
  include WithBlobs
  include WithPosition
  include WithSlug

  has_summernote :text
  has_one_attached :pdf

  belongs_to :journal, foreign_key: :research_journal_id
  belongs_to :volume, foreign_key: :research_journal_volume_id, optional: true
  belongs_to :kind, class_name: 'Research::Journal::Paper::Kind', optional: true
  belongs_to :updated_by, class_name: 'User'
  has_and_belongs_to_many :people,
                          class_name: 'University::Person',
                          join_table: :research_journal_papers_researchers,
                          association_foreign_key: :researcher_id
  has_many :websites, -> { distinct }, through: :journal

  validates :title, presence: true

  before_validation :set_published_at, if: :published_changed?

  scope :published, -> { where(published: true) }
  scope :ordered, -> { order(published_at: :desc, created_at: :desc) }

  def git_path(website)
    "#{git_path_content_prefix(website)}papers/#{published_at.year}#{path}.html" if published_at
  end

  def template_static
    "admin/research/journals/papers/static"
  end

  def git_dependencies(website)
    [self] +
    active_storage_blobs +
    other_papers_in_the_volume +
    people +
    people.map(&:active_storage_blobs).flatten +
    people.map(&:researcher) +
    website.menus
  end

  def to_s
    "#{ title }"
  end

  def path
    "/#{published_at.strftime "%Y-%m-%d"}-#{slug}" if published_at
  end

  protected

  def other_papers_in_the_volume
    return [] if volume.nil?
    volume.papers.where.not(id: self)
  end

  def last_ordered_element
    Research::Journal::Paper.where(
      university_id: university_id,
      research_journal_volume_id: research_journal_volume_id
    ).ordered.last
  end

  def explicit_blob_ids
    super.concat [pdf&.blob_id]
  end

  def set_published_at
    self.published_at = published? ? Time.zone.now : nil
  end
end
