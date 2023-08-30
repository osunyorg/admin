# == Schema Information
#
# Table name: research_journal_papers
#
#  id                         :uuid             not null, primary key
#  abstract                   :text
#  accepted_at                :date
#  authors_list               :text
#  bibliography               :text
#  doi                        :string
#  keywords                   :text
#  meta_description           :text
#  position                   :integer
#  published                  :boolean          default(FALSE)
#  published_at               :datetime
#  received_at                :date
#  slug                       :string
#  summary                    :text
#  text                       :text
#  title                      :string
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  kind_id                    :uuid             indexed
#  research_journal_id        :uuid             not null, indexed
#  research_journal_volume_id :uuid             indexed
#  university_id              :uuid             not null, indexed
#  updated_by_id              :uuid             indexed
#
# Indexes
#
#  index_research_journal_papers_on_kind_id                     (kind_id)
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
#  fk_rails_db4e38788c  (kind_id => research_journal_paper_kinds.id)
#
class Research::Journal::Paper < ApplicationRecord
  include AsIndirectObject
  include Sanitizable
  include WithBlobs
  include WithBlocks
  include WithCitations
  include WithGitFiles
  include WithPermalink
  include WithPosition
  include WithPublication
  include WithSlug
  include WithUniversity

  has_summernote :bibliography
  has_summernote :text
  has_one_attached :pdf

  belongs_to  :journal, 
              foreign_key: :research_journal_id
  belongs_to  :volume, 
              foreign_key: :research_journal_volume_id, 
              optional: true
  belongs_to  :kind, 
              class_name: 'Research::Journal::Paper::Kind', 
              optional: true
  belongs_to  :updated_by, 
              class_name: 'User'
  has_and_belongs_to_many :people,
                          class_name: 'University::Person',
                          join_table: :research_journal_papers_researchers,
                          association_foreign_key: :researcher_id

  validates :title, presence: true

  scope :ordered, -> { order(:position, published_at: :desc, created_at: :desc) }

  def git_path(website)
    "#{git_path_content_prefix(website)}papers/#{static_path}.html" if published?
  end

  def static_path
    "#{published_at.year}/#{published_at.strftime "%Y-%m-%d"}-#{slug}"
  end

  def template_static
    "admin/research/journals/papers/static"
  end

  def dependencies
    active_storage_blobs +
    blocks +
    people.map(&:researcher)
  end

  def references
    references = people + [journal]
    references << volume if volume.present?
    references
  end

  def doi_url
    Doi.url doi
  end

  def to_s
    "#{ title }"
  end

  protected

  def to_citeproc(website: nil)
    citeproc = {
      "title" => title,
      "author" => people.map { |person|
        { "family" => person.last_name, "given" => person.first_name }
      },
      "URL" => website.url + Communication::Website::Permalink.for_object(self, website).computed_path,
      "container-title" => journal.title,
      "volume" => volume&.number,
      "keywords" => keywords,
      "pdf" => pdf.attached? ? pdf.url : nil,
      "id" => id
    }
    citeproc["DOI"] = doi if doi.present?
    if published_at.present?
      citeproc["month-numeric"] = published_at.month.to_s
      citeproc["issued"] = { "date-parts" => [[published_at.year, published_at.month]] }
    end
    citeproc
  end

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
end
