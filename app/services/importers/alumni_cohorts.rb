module Importers
  class AlumniCohorts < Base

    protected

    def analyze_hash(hash, index)
      hash_to_alumnus = HashToAlumnus.new(@university, hash)
      if hash_to_alumnus.valid?
        person = hash_to_alumnus.person
        hash_to_cohort = HashToCohort.new(person, hash)
        add_error(hash_to_cohort.error, index + 1) unless hash_to_cohort.valid?
      else
        add_error(hash_to_alumnus.error, index + 1)
      end
    end

  end

end
