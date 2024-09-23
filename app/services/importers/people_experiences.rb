module Importers
  class PeopleExperiences < Base

    protected

    def analyze_hash(hash, index)
      hash_to_person = HashToPerson.new(@university, @language, hash)
      if hash_to_person.valid?
        person = hash_to_person.person
        hash_to_experience = HashToExperience.new(person, @language, hash)
        add_error(hash_to_experience.error, index + 1) unless hash_to_experience.valid?
      else
        add_error(hash_to_person.error, index + 1)
      end
    end

  end
end
