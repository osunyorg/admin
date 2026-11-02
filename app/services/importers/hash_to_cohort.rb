module Importers
  class HashToCohort
    def initialize(person, hash)
      @university = person.university
      @hash = hash
      @error = nil
      extract_variables
      add_to_cohort(person, cohort) if valid?
    end

    def valid?
      if school.nil?
        @error = "School #{@school_id} not found"
      elsif program.nil?
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

    def extranet_ids
      @extranet_ids ||= begin
        program_extranet_ids = @university.communication_extranets.where(about: program).pluck(:id)
        school_extranet_ids = @university.communication_extranets.where(about: school).pluck(:id)
        program_extranet_ids + school_extranet_ids
      end
    end

    protected

    def add_to_cohort(person, cohort)
      person.add_cohort(cohort)
    end

    def extract_variables
      @school_id = @hash[offset].to_s.strip
      # offset + 1 is the school name, we don't use it
      @program_id = @hash[offset + 2].to_s.strip
      # offset + 3 is the program name, we don't use it
      @year = @hash[offset + 4].to_s.strip.to_i
    end

    def school
      @university.education_schools.find_by(id: @school_id)
    end

    def program
      @university.education_programs.find_by(id: @program_id)
    end

    def academic_year
      @academic_year ||= @university.academic_years.where(year: @year).first_or_create
    end

    def cohort
      @cohort ||= @university.administration_cohorts
                       .where(school: school, program: program, academic_year: academic_year)
                       .first_or_create
    end

    def offset
      @offset ||= Importers::HashToPerson::NUMBER_OF_COLUMNS
    end

  end
end
