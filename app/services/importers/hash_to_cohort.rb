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

    protected


    def add_to_cohort(person, cohort)
      add_object_if_necessary cohort, person.cohorts
      add_object_if_necessary cohort.academic_year, person.diploma_years
      add_object_if_necessary cohort.program, person.diploma_programs
    end

    def add_object_if_necessary(object, list)
      list << object unless object.in?(list)
    end

    def extract_variables
      @school_id = @hash[offset].to_s.strip
      @program_id = @hash[offset + 1].to_s.strip
      @year = @hash[offset + 2].to_s.strip.to_i
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
      @cohort ||= @university.education_cohorts
                       .where(school: school, program: program, academic_year: academic_year)
                       .first_or_create
    end

    def offset
      @offset ||= Importers::HashToPerson::NUMBER_OF_COLUMNS
    end

  end
end
