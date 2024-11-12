module Importers
  class HashToExperience
    def initialize(person, language, hash)
      @person = person
      @language = language
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
      @company_name = @hash[offset].to_s.strip
      @company_siren = @hash[offset + 1].to_s.strip
      @company_nic = @hash[offset + 2].to_s.strip
      @experience_job = @hash[offset + 3].to_s.strip
      @experience_from = @hash[offset + 4].to_s.strip
      @experience_to = @hash[offset + 5].to_s.strip
    end

    def experience
      @experience ||= begin
        obj =  @person.experiences
                      .where(university: @university,
                            organization: organization,
                            from_year: @experience_from)
                      .first_or_initialize
        localization_id = obj.localizations.find_by(language_id: @language.id)&.id
        obj.to_year = @experience_to
        obj.localizations_attributes = [
          {
            id: localization_id, language_id: @language.id,
            description: @experience_job
          }
        ]
        obj.save
        obj
      end
    end

    def organization
      @organization ||= begin
        # Search by SIREN+NIC, then SIREN, then name, or create it with everything
        if @company_siren.present? && @company_nic.present?
          obj = find_organization_with_siren_and_nic
        elsif @company_siren.present?
          obj = find_organization_with_siren
        end
        obj ||= find_organization_with_name_in_current_language
        obj ||= find_organization_with_name_in_another_language
        obj ||= create_organization
        obj
      end
    end

    def find_organization_with_siren_and_nic
      @university.organizations.find_by(siren: @company_siren, nic: @company_nic)
    end

    def find_organization_with_siren
      @university.organizations.find_by(siren: @company_siren)
    end

    def find_organization_with_name_in_current_language
      @university.organizations
        .joins(:localizations)
        .where(university_organization_localizations: {
          language_id: @language.id, name: @company_name
        })
        .first
    end

    def find_organization_with_name_in_another_language
      @university.organizations
        .joins(:localizations)
        .where.not(university_organization_localizations: {
          language_id: @language.id
        })
        .where(university_organization_localizations: {
          name: @company_name
        })
        .first
    end

    def create_organization
      @university.organizations.create(
        siren: @company_siren, nic: @company_nic,
        localizations_attributes: [
          { language_id: @language.id, name: @company_name }
        ]
      )
    end

    def offset
      @offset ||= Importers::HashToPerson::NUMBER_OF_COLUMNS
    end
  end
end
