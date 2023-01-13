module University::Person::WithResearch
  extend ActiveSupport::Concern

  included do
    has_many :research_documents, class_name: 'Research::Document', foreign_key: :university_person_id
  end

  def hal_identity?
    hal_form_identifier.present?
  end

  def load_research_documents!
    return unless hal_identity?
    response = HalOpenscience::Document.search  "authIdForm_i:#{hal_form_identifier}",
                                                fields: ["docid", "title_s", "citationRef_s", "uri_s"],
                                                limit: 1000
    response.results.each do |doc|
      document = Research::Document.where(university: university, person: self, docid: doc.docid).first_or_create
      document.title = doc.title_s[0]
      document.ref = doc.citationRef_s
      document.url = doc.uri_s
      document.save
    end
  end

  def possible_hal_authors
    HalOpenscience::Author.search(to_s, fields: ['*']).results
  end

end
