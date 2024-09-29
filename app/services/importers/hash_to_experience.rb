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
      @company_name = @hash[18].to_s.strip
      @company_siren = @hash[19].to_s.strip
      @company_nic = @hash[20].to_s.strip
      @experience_job = @hash[21].to_s.strip
      @experience_from = @hash[22].to_s.strip
      @experience_to = @hash[23].to_s.strip
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
      @university.organizations.tmp_original.find_by(siren: @company_siren, nic: @company_nic)
    end

    def find_organization_with_siren
      @university.organizations.tmp_original.find_by(siren: @company_siren)
    end

    def find_organization_with_name_in_current_language
      @university.organizations.tmp_original
        .joins(:localizations)
        .where(university_organization_localizations: {
          language_id: @language.id, name: @company_name
        })
        .first
    end

    def find_organization_with_name_in_another_language
      @university.organizations.tmp_original
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
  end
end
