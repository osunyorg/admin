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
  include Filterable
  include Permalinkable
  include Sanitizable
  include WithCitations
  include WithGitFiles

  enum source: {
    osuny: 0,
    hal: 1
  }

  has_and_belongs_to_many :researchers,
                          class_name: 'University::Person',
                          foreign_key: :research_publication_id,
                          association_foreign_key: :university_person_id

  has_and_belongs_to_many :authors,
                          class_name: 'Research::Hal::Author',
                          foreign_key: :research_publication_id,
                          association_foreign_key: :research_hal_author_id

  validates :title, :publication_date, presence: true

  before_validation :generate_authors_citeproc

  scope :ordered, -> (language = nil) { order(publication_date: :desc)}
  scope :for_search_term, -> (term, language = nil) {
    where("
      unaccent(research_publications.abstract) ILIKE unaccent(:term) OR
      unaccent(research_publications.citation_full) ILIKE unaccent(:term)
    ", term: "%#{sanitize_sql_like(term)}%")
  }

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

  # Override to handle default language
  def hugo_ancestors_for_special_page(website)
    return [] if is_a?(Communication::Website::Page::Localization)
    permalink = Communication::Website::Permalink.for_object(self, website)
    return [] unless permalink
    special_page = permalink.special_page(website)
    return [] unless special_page
    special_page_l10n = special_page.localization_for(website.default_language)
    return [] unless special_page_l10n
    special_page_l10n.ancestors_and_self
  end

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
      researcher_l10n = researcher.original_localization
      {
        "family" => researcher_l10n.last_name,
        "given" => researcher_l10n.first_name
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
