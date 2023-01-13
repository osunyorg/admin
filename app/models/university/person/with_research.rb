module University::Person::WithResearch
  extend ActiveSupport::Concern

  included do
    has_many :research_documents
  end

  def load_research_documents!
    url = "https://api.archives-ouvertes.fr/search/?q=authIdPerson_i:#{hal_person_identifier}&fl=title_s,citationRef_s,uri_s&rows=1000"
    uri = URI(url)
    response = Net::HTTP.get(uri)
    data = JSON.parse(response)
    data['response']['docs'].each do |doc|
      document = Research::Document.where(university: university, person: self, docid: doc['docid']).first_or_create
      document.title = doc['title_s'][0]
      document.ref = doc['citationRef_s']
      document.url = doc['uri_s']
      document.save
    end
  end

end
