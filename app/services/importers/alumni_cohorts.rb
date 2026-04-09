module Importers
  class AlumniCohorts < Base

    def initialize(import)
      @import = import
      @language = import.language
      @university = import.university
      @connections = []
      @errors = []
      analyze_xlsx
      manage_errors
      save
      send_extranet_invitation_emails
    end

    protected

    def analyze_hash(hash, index)
      hash_to_alumnus = HashToAlumnus.new(@university, @language, hash)
      if hash_to_alumnus.valid?
        person = hash_to_alumnus.person
        hash_to_cohort = HashToCohort.new(person, hash)
        if hash_to_cohort.valid?
          hash_to_cohort.extranet_ids.each do |extranet_id|
            @connections << { person_id: person.id, communication_extranet_id: extranet_id }
          end
        else
          add_error(hash_to_cohort.error, index + 1) 
        end
      else
        add_error(hash_to_alumnus.error, index + 1)
      end
    end

    def send_extranet_invitation_emails
      @connections.uniq.each do |connection|
        extranet = @university.communication_extranets.find(connection[:communication_extranet_id])
        person = @university.people.find(connection[:person_id])
        ExtranetMailer.invitation_message(extranet, person).deliver_later
      end
    end

  end

end
