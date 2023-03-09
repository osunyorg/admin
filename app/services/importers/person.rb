module Importers
  class Person < Base

    protected

    def analyze_hash(hash, index)
      hash_to_person = HashToPerson.new(@university, hash)
      add_error(hash_to_person.error, index + 1) unless hash_to_person.valid?
    end

  end
  
end
