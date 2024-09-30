module Importers
  class HashToOrganization
    def initialize(university, language, hash)
      @university = university
      @language = language
      @hash = hash
      @error = nil
      extract_variables
      save if valid?
    end

    def valid?
      if country_not_found?
        @error = "Country #{@country} not found"
      elsif !organization.valid?
        @error = "Unable to create the organization: #{organization.errors.full_messages}"
      end
      @error.nil?
    end

    def error
      @error
    end

    def organization_name
      @organization_name ||= @hash[0].to_s.strip
    end

    protected

    def extract_variables
      @long_name = @hash[1].to_s.strip
      @kind = @hash[2].to_s.strip
      @siren = @hash[3].to_s.strip
      @nic = @hash[4].to_s.strip
      @meta_description = @hash[5].to_s.strip
      @address = @hash[6].to_s.strip
      @zipcode = @hash[7].to_s.strip
      @city = @hash[8].to_s.strip
      @country = @hash[9].to_s.strip
      @email = @hash[10].to_s.strip
      @phone = @hash[11].to_s.strip
      @url = @hash[12].to_s.strip
    end

    def country_not_found?
      ISO3166::Country[@country].nil?
    end

    def organization
      unless @organization
        if @siren.present? && @nic.present?
          @organization = find_organization_with_siren_and_nic
        elsif @siren.present?
          @organization = find_organization_with_siren
        end
        @organization ||= find_organization_with_name_in_current_language
        @organization ||= find_organization_with_name_in_another_language
        @organization ||= @university.organizations.new
        localization_id = @organization.localizations.find_by(language_id: @language.id)&.id
        @organization.kind = @kind.to_sym
        @organization.siren = @siren
        @organization.nic = @nic
        @organization.address = @address
        @organization.zipcode = @zipcode
        @organization.city = @city
        @organization.country = @country
        @organization.email = @email
        @organization.phone = @phone
        @organization.localizations_attributes = [
          {
            id: localization_id, language_id: @language.id,
            long_name: @long_name, meta_description: @meta_description,
            name: organization_name, url: @url
          }
        ]
      end
      @organization
    end

    def find_organization_with_siren_and_nic
      @university.organizations.find_by(siren: @siren, nic: @nic)
    end

    def find_organization_with_siren
      @university.organizations.find_by(siren: @siren)
    end

    def find_organization_with_name_in_current_language
      @university.organizations
        .joins(:localizations)
        .where(university_organization_localizations: {
            language_id: @language.id,
            name: organization_name
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
          name: organization_name
        })
        .first
    end

    def save
      organization.save
    end
  end
end
