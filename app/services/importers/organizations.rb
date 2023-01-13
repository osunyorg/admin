module Importers
  class Organizations < Base

    protected

    def analyze_hash(hash, index)
      hash_to_organization = HashToOrganization.new(@university, hash)
      add_error(hash_to_organization.error, index + 1) unless hash_to_organization.valid?
    end

  end

  class HashToOrganization
    def initialize(university, hash)
      @university = university
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
        @organization = University::Organization.where(university_id: @university.id, name: organization_name).first_or_initialize
        @organization.long_name = @long_name
        @organization.kind = @kind.to_sym
        @organization.siren = @siren
        @organization.nic = @nic
        @organization.meta_description = @meta_description
        @organization.address = @address
        @organization.zipcode = @zipcode
        @organization.city = @city
        @organization.country = @country
        @organization.email = @email
        @organization.phone = @phone
        @organization.url = @url
      end
      @organization
    end

    def save
      organization.save
    end
  end
end
