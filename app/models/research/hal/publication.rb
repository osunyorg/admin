# == Schema Information
#
# Table name: research_hal_publications
#
#  id               :uuid             not null, primary key
#  data             :jsonb
#  docid            :string           indexed
#  doi              :string
#  hal_url          :string
#  publication_date :date
#  ref              :string
#  slug             :string
#  title            :string
#  url              :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_research_hal_publications_on_docid  (docid)
#
class Research::Hal::Publication < ApplicationRecord
  include Sanitizable
  include WithGit
  include WithSlug

  has_and_belongs_to_many :researchers,
                          class_name: 'University::Person',
                          foreign_key: 'university_person_id',
                          association_foreign_key: 'research_hal_publication_id'

  has_and_belongs_to_many :authors,
                          foreign_key: 'research_hal_author_id',
                          association_foreign_key: 'research_hal_publication_id'

  validates_presence_of :docid

  scope :ordered, -> { order(publication_date: :desc)}

  def self.import_from_hal_for_author(author)
    fields = [
      'docid',
      'title_s',
      'citationRef_s',
      'uri_s',
      'doiId_s',
      'publicationDate_tdate',
      'linkExtUrl_s',
      # '*',
    ]
    publications = []
    response = HalOpenscience::Document.search "authIdFormPerson_s:#{author.docid}", fields: fields, limit: 1000
    response.results.each do |doc|
      publication = create_from doc
      publications << publication
    end
    publications
  end

  def self.create_from(doc)
    publication = where(docid: doc.docid).first_or_create
    puts "HAL sync publication #{doc.docid}"
    publication.title = Osuny::Sanitizer.sanitize doc.title_s.first, 'string'
    publication.ref = doc.attributes['citationRef_s']
    publication.hal_url = doc.attributes['uri_s']
    publication.doi = doc.attributes['doiId_s']
    publication.publication_date = doc.attributes['publicationDate_tdate']
    publication.url = doc.attributes['linkExtUrl_s']
    publication.save
    publication
  end

  def template_static
    "admin/research/publications/static"
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

  def slug_unavailable?(slug)
    self.class.unscoped
              .where(slug: slug)
              .where.not(id: self.id)
              .exists?
  end
end
