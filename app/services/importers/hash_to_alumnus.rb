module Importers
  class HashToAlumnus < HashToPerson

    def person
      @person ||= begin
        person = build_person
        person.is_alumnus = true
        person
      end
    end

  end
end
