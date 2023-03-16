module Importers
  class HashToCohort
    def initialize(person, hash)
      @university = person.university
      @hash = hash
      @error = nil
      extract_variables
      person.add_to_cohort cohort if valid?
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

    def extract_variables
      @school_id = @hash[17].to_s.strip
      @program_id = @hash[18].to_s.strip
      @year = @hash[19].to_s.strip.to_i
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

  end
end
