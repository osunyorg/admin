module Importers
  class Hal

    # https://api.archives-ouvertes.fr/search/?q=03713859&fl=*
    def self.import_publications_for_author(author)
      fields = [
        'docid',
        'title_s',
        'citationRef_s',
        'citationFull_s',
        'uri_s',
        'doiId_s',
        'publicationDate_tdate',
        'linkExtUrl_s',
        'abstract_s',
        'openAccess_bool',
        'journalTitle_s',
        'authFullName_s',
        'authLastName_s',
        'authFirstName_s',
        'files_s'
        # '*',
      ]
      publications = []
      response = HalOpenscience::Document.search "authIdFormPerson_s:#{author.docid}", fields: fields, limit: 1000
      response.results.each do |doc|
        publication = create_publication_from doc
        publications << publication
      end
      publications
    end

    def self.create_publication_from(doc)
      publication = Research::Publication.where(hal_docid: doc.docid).first_or_create
      puts "HAL sync publication #{doc.docid}"
      publication.source = :hal
      publication.title = Osuny::Sanitizer.sanitize doc.title_s.first, 'string'
      publication.ref = doc.attributes['citationRef_s']
      publication.citation_full = doc.attributes['citationFull_s']
      publication.abstract = doc.attributes['abstract_s']&.first
      publication.hal_url = doc.attributes['uri_s']
      publication.doi = doc.attributes['doiId_s']
      publication.publication_date = doc.attributes['publicationDate_tdate']
      publication.url = doc.attributes['linkExtUrl_s']
      publication.open_access = doc.attributes['openAccess_bool']
      publication.journal_title = doc.attributes['journalTitle_s']
      publication.file = doc.attributes['files_s']&.first
      publication.authors_list = doc.attributes['authFullName_s'].join(', ')
      publication.authors_citeproc = []
      doc.attributes['authLastName_s'].each_with_index do |last_name, index|
        publication.authors_citeproc << {
          "family" => last_name, 
          "given" => doc.attributes['authFirstName_s'][index]
        }
      end
      publication.save
      publication
    end

  end
end