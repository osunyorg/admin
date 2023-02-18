module University::Person::WithResearch
  extend ActiveSupport::Concern

  included do
    has_and_belongs_to_many :research_hal_authors,
                            class_name: 'Research::Hal::Author', 
                            foreign_key: 'research_hal_author_id',
                            association_foreign_key: 'university_person_id'
    alias :hal_authors :research_hal_authors

    has_and_belongs_to_many :research_hal_publications,
                            class_name: 'Research::Hal::Publication', 
                            foreign_key: 'research_publication_id',
                            association_foreign_key: 'university_person_id'
    alias :hal_publications :research_hal_publications
    alias :publications :research_hal_publications

    scope :with_hal_identifier, -> { where.not(hal_form_identifier: [nil,'']) }
  end

  def import_research_hal_publications!
    hal_authors.each do |author|
      author.import_research_hal_publications!
    end
    response = HalOpenscience::Document.search  "authIdForm_i:#{hal_form_identifier}",
                                                fields: ["*"],
                                                limit: 1000
    response.results.each do |doc|
      publication = Research::Hal::Publication.create_from doc
      publications << publication unless publication.in?(publications)
    end
  end
  handle_asynchronously :import_research_hal_publications!

end
