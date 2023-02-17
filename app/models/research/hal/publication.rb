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
  include WithGit
  include WithSlug

  DOI_PREFIX = 'http://dx.doi.org/'.freeze

  has_and_belongs_to_many :publications

  before_destroy { research_people.clear }

  validates_presence_of :docid

  scope :ordered, -> { order(publication_date: :desc)}

  def self.create_from(doc)
    publication = where(docid: doc.docid).first_or_create
    puts "pub-- #{where(docid: doc.docid).count}"
    publication.title = Osuny::Sanitizer.sanitize doc.title_s.first, 'string'
    publication.ref = doc.attributes['citationRef_s']
    publication.hal_url = doc.attributes['uri_s']
    publication.doi = doc.attributes['doiId_s']
    publication.publication_date = doc.attributes['publicationDate_tdate']
    publication.url = doc.attributes['linkExtUrl_s']
    publication.save
    publication
  end

  def self.update_from_hal
    University::Person::Researcher.with_hal_identifier.find_each do |researcher|
      # puts "Loading publications for #{researcher} (#{researcher.university})"
      researcher.import_research_hal_publications!
    end
  end

  def template_static
    "admin/research/publications/static"
  end

  def doi_url
    return unless doi.present?
    "#{DOI_PREFIX}#{doi}"
  end

  def best_url
    doi_url || url || hal_url
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
