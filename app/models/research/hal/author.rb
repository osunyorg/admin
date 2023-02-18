# == Schema Information
#
# Table name: research_hal_authors
#
#  id                :uuid             not null, primary key
#  docid             :string           indexed
#  first_name        :string
#  form_identifier   :string
#  full_name         :string
#  last_name         :string
#  person_identifier :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_research_hal_authors_on_docid  (docid)
#
class Research::Hal::Author < ApplicationRecord
  has_and_belongs_to_many :publications,
                          foreign_key: 'research_hal_publication_id',
                          association_foreign_key: 'research_hal_author_id'
  has_and_belongs_to_many :university_person_researchers,
                          class_name: 'University::Person',
                          foreign_key: 'university_person_id',
                          association_foreign_key: 'research_hal_author_id'
  alias :researchers :university_person_researchers

  scope :ordered, -> { order(:last_name, :first_name, :docid)}

  def self.import_from_hal(full_name)
    authors = []
    fields = [
      'docid',
      'form_i',
      'person_i',
      'firstName_s',
      'lastName_s',
      'fullName_s'
    ]
    HalOpenscience::Author.search(full_name, fields: fields).results.each do |doc|
      authors << create_from(doc)
    end
    authors
  end

  def self.create_from(doc)
    author = where(docid: doc.docid).first_or_create
    author.form_identifier = doc.form_i
    author.person_identifier = doc&.person_i if doc.attributes.has_key?(:person_i)
    author.first_name = doc.firstName_s
    author.last_name = doc.lastName_s
    author.full_name = doc.fullName_s
    author.save
    author
  end

  # Direct import from HAL, does not return persisted publications
  def sample_documents
    HalOpenscience::Document.search("authIdFormPerson_s:#{docid}", fields: ['citationFull_s'], limit: 5)
                            .results
                            .collect(&:citationFull_s)
  end

  def import_research_hal_publications!
    # Do not use the API if no researcher is concerned
    return if researchers.none?
    Research::Hal::Publication.import_from_hal_for_author(self)
  end

  def connect_researcher(researcher)
    researchers << researcher
  end
  
  def disconnect_researcher(researcher)
    researchers.delete researcher
  end

  def to_s
    "#{full_name}"
  end
end
