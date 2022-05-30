module Importers
  class AlumniCohorts < Importers::Alumni

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

  class HashToCohort
    def initialize(person, hash)
      @university = person.university
      @hash = hash
      @error = nil
      extract_variables
      person.add_to_cohort cohort if valid?
    end

    def valid?
      if program.nil?
        @error = "Program #{@program_id} not found"
      elsif academic_year.nil?
        @error = "The year #{@year} seems incorrect"
      elsif cohort.nil?
        @error = "Unable to create the cohort"
      end
      @error.nil?
    end

    def error
      @error
    end

    protected

    def extract_variables
      @program_id = @hash[17].to_s.strip
      @year = @hash[18].to_s.strip.to_i
    end

    def program
      @university.education_programs.find_by(id: @program_id)
    end

    def academic_year
      @academic_year ||= @university.academic_years.where(year: @year).first_or_create
    end

    def cohort
      @cohort ||= @university.education_cohorts
                       .where(program: program, academic_year: academic_year)
                       .first_or_create
    end

  end

end
