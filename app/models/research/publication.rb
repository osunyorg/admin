# == Schema Information
#
# Table name: research_publications
#
#  id               :uuid             not null, primary key
#  abstract         :text
#  authors_citeproc :json
#  authors_list     :text
#  citation_full    :text
#  data             :jsonb
#  doi              :string
#  file             :text
#  hal_docid        :string           indexed
#  hal_url          :string
#  journal_title    :string
#  open_access      :boolean
#  publication_date :date
#  ref              :string
#  slug             :string           indexed
#  source           :integer          default("osuny")
#  title            :string
#  url              :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_research_publications_on_hal_docid  (hal_docid)
#  index_research_publications_on_slug       (slug)
#
class Research::Publication < ApplicationRecord
  include AsIndirectObject
  include Permalinkable
  include Sanitizable
  include WithCitations
  include WithGitFiles

  has_and_belongs_to_many :researchers,
                          class_name: 'University::Person',
                          foreign_key: :research_publication_id,
                          association_foreign_key: :university_person_id

  has_and_belongs_to_many :authors,
                          class_name: 'Research::Hal::Author',
                          foreign_key: :research_publication_id,
                          association_foreign_key: :research_hal_author_id

  scope :ordered, -> { order(publication_date: :desc)}

  enum source: {
    osuny: 0,
    hal: 1
  }

  validates_presence_of :title, :publication_date

  before_validation :generate_authors_citeproc

  def editable?
    source == 'osuny'
  end

  def template_static
    "admin/research/publications/static"
  end

  def git_path(website)
    "#{git_path_content_prefix(website)}publications/#{publication_date.year}/#{slug}.html" if for_website?(website)
  end

  def doi_url
    Doi.url doi
  end

  def best_url
    url || doi_url || hal_url
  end

  def to_s
    "#{title}"
  end

  protected

  def to_citeproc(website: nil)
    {
      "title" => title,
      "author" => authors_citeproc,
      "URL" => best_url,
      "container-title" => journal_title,
      "pdf" => file,
      "month-numeric" => publication_date.present? ? publication_date.month.to_s : nil,
      "issued" => publication_date.present? ? { "date-parts" => [[publication_date.year, publication_date.month]] } : nil,
      "id" => (hal_docid || id)
    }
  end

  def generate_authors_citeproc
    return if hal?
    self.authors_citeproc = researchers.map do |researcher|
      {
        "family" => researcher.last_name,
        "given" => researcher.first_name
      }
    end
  end

  def slug_unavailable?(slug)
    self.class.unscoped
              .where(slug: slug)
              .where.not(id: self.id)
              .exists?
  end
end
