module Importers
  class AlumniExperiences < Importers::Alumni

    protected

    def analyze_hash(hash, index)
      hash_to_alumnus = HashToAlumnus.new(@university, hash)
      if hash_to_alumnus.valid?
        person = hash_to_alumnus.person
        hash_to_experience = HashToExperience.new(person, hash)
        add_error(hash_to_experience.error, index + 1) unless hash_to_experience.valid?
      else
        add_error(hash_to_alumnus.error, index + 1)
      end
    end

  end

  class HashToExperience
    def initialize(person, hash)
      @person = person
      @university = person.university
      @hash = hash
      @error = nil
      extract_variables
    end

    def valid?
      if organization.nil?
        @error = "Unable to create the organization #{@company_name}"
      elsif experience.nil?
        @error = "Unable to create the experience"
      end
      @error.nil?
    end

    def error
      @error
    end

    protected

    def extract_variables
      @company_name = @hash[17].to_s.strip
      @company_siren = @hash[18].to_s.strip
      @company_nic = @hash[19].to_s.strip
      @experience_job = @hash[20].to_s.strip
      @experience_from = @hash[21].to_s.strip
      @experience_to = @hash[22].to_s.strip
    end

    def experience
      @experience ||= begin
        obj = @person.experiences
                         .where(university: @university,
                                organization: organization,
                                from_year: @experience_from)
                         .first_or_create
        obj.description = @experience_job
        obj.to_year = @experience_to
        obj.save
        obj
      end
    end

    def organization
      @organization ||= begin
        # Search by SIREN+NIC, then SIREN, then name, or create it with everything
        if @company_siren.present? && @company_nic.present?
          obj = @university.organizations
                                   .find_by siren: @company_siren,
                                            nic: @company_nic
        elsif @company_siren.present?
          obj = @university.organizations
                                   .find_by siren: @company_siren
        end
        obj ||= @university.organizations
                                   .find_by name: @company_name
        obj ||= @university.organizations
                                   .where( name: @company_name,
                                           siren: @company_siren,
                                           nic: @company_nic)
                                   .first_or_create
        obj
      end
    end


  end

end
