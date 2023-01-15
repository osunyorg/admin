module University::Person::WithResearch
  extend ActiveSupport::Concern

  included do
    has_and_belongs_to_many :research_publications,
                            class_name: 'Research::Publication', 
                            foreign_key: 'research_publication_id',
                            association_foreign_key: 'university_person_id'
  end

  def hal_identity?
    hal_form_identifier.present?
  end

  def load_research_publications!
    return unless hal_identity?
    response = HalOpenscience::Document.search  "authIdForm_i:#{hal_form_identifier}",
                                                fields: ["docid", "title_s", "citationRef_s", "uri_s", "*"],
                                                limit: 1000
    response.results.each do |doc|
      publication = Research::Publication.create_from doc
      research_publications << publication unless publication.in?(research_publications)
    end
  end

  def possible_hal_authors
    HalOpenscience::Author.search(to_s, fields: ['*']).results
  end

end
