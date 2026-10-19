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
      @organization_name ||= @hash[1].to_s.strip
    end

    protected

    def extract_variables
      @id = @hash[0].to_s.strip
      @long_name = @hash[2].to_s.strip
      @kind = @hash[3].to_s.strip
      @siren = @hash[4].to_s.strip
      @nic = @hash[5].to_s.strip
      @meta_description = @hash[6].to_s.strip
      @address_name = @hash[7].to_s.strip
      @address = @hash[8].to_s.strip
      @address_additional = @hash[9].to_s.strip
      @zipcode = @hash[10].to_s.strip
      @city = @hash[11].to_s.strip
      @country = @hash[12].to_s.strip
      @email = @hash[13].to_s.strip
      @phone = @hash[14].to_s.strip
      @url = @hash[15].to_s.strip
      @linkedin = @hash[16].to_s.strip
      @twitter = @hash[17].to_s.strip
      @mastodon = @hash[18].to_s.strip
      @category_names = @hash[19].to_s.split('|').map { |category_name| category_name.strip }
    end

    def country_not_found?
      @country.present? && ISO3166::Country[@country].nil?
    end

    def organization
      unless @organization
        @organization = find_or_initialize_organization
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
            name: organization_name, long_name: @long_name,
            meta_description: @meta_description,
            address_name: @address_name, address_additional: @address_additional,
            url: @url, linkedin: @linkedin, twitter: @twitter, mastodon: @mastodon
          }
        ]
        @organization.categories = categories
      end
      @organization
    end

    def find_or_initialize_organization
      organization = find_organization_with_id
      if @siren.present? && @nic.present?
        organization ||= find_organization_with_siren_and_nic
      elsif @siren.present?
        organization ||= find_organization_with_siren
      end
      organization ||= find_organization_with_name_in_current_language
      organization ||= find_organization_with_name_in_another_language
      organization ||= @university.organizations.new
      organization
    end

    def find_organization_with_id
      @university.organizations.find_by(id: @id)
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

    def categories
      @category_names.map do |category_name|
        category = find_category_with_name_in_current_language(category_name)
        category ||= find_category_with_name_in_another_language(category_name)
        category ||= @university.organization_categories.create(
          localizations_attributes: [
            { name: category_name, language_id: @language.id }
          ]
        )
        category
      end
    end

    def find_category_with_name_in_current_language(category_name)
      @university.organization_categories
        .joins(:localizations)
        .where(university_organization_category_localizations: {
          language_id: @language.id, name: category_name
        })
        .first
    end

    def find_category_with_name_in_another_language(category_name)
      @university.organization_categories
        .joins(:localizations)
        .where.not(university_organization_category_localizations: {
          language_id: @language.id
        })
        .where(university_organization_category_localizations: {
          name: category_name
        })
        .first
    end

    def save
      organization.save
    end
  end
end
