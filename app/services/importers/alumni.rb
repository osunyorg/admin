module Importers
  class Alumni < Base

    protected

    def analyze_hash(hash, index)
      hash_to_alumnus = HashToAlumnus.new(@university, hash)
      add_error(hash_to_alumnus.error, index + 1) unless hash_to_alumnus.valid?
    end

  end

  class HashToAlumnus
    def initialize(university, hash)
      @university = university
      @hash = hash
      @error = nil
      extract_variables
      person.save
      # manage picture
      # save if valid?
    end

    def valid?
      if country_not_found?
        @error = "Country #{@country} not found"
      elsif !person.valid?
        @error = "Unable to create the person: #{person.errors.full_messages}"
      end
      @error.nil?
    end

    def error
      @error
    end

    def organization_name
      @organization_name ||= @hash[0].to_s.strip
    end

    def program
      @program ||= @hash[0].to_s.strip
    end

    protected

    def extract_variables
      @program_id = @hash[0].to_s.strip
      @year = @hash[1].to_s.strip
      @first_name = @hash[2].to_s.strip
      @last_name = @hash[3].to_s.strip
      @gender = @hash[4].to_s.strip
      @birth = @hash[5].to_s.strip
      @email = @hash[6].to_s.strip
      @photo = @hash[7].to_s.strip
      @url = @hash[8].to_s.strip
      @phone_professional = @hash[9].to_s.strip
      @phone_personal = @hash[10].to_s.strip
      @mobile = @hash[11].to_s.strip
      @address = @hash[12].to_s.strip
      @zipcode = @hash[13].to_s.strip
      @city = @hash[14].to_s.strip
      @country = @hash[15].to_s.strip
      @biography = @hash[16].to_s.strip
      @social_twitter = @hash[17].to_s.strip
      @social_linkedin = @hash[18].to_s.strip
      @company_name = @hash[19].to_s.strip
      @company_siren = @hash[20].to_s.strip
      @company_nic = @hash[21].to_s.strip
      @experience_job = @hash[22].to_s.strip
      @experience_from = @hash[23].to_s.strip
      @experience_to = @hash[24].to_s.strip
    end

    def country_not_found?
      ISO3166::Country[@country].nil?
    end

    def person
      # TODO: add missing properties
      @person ||= begin
        if @email.present?
          person = university.people
                             .where(email: @email)
                             .first_or_initialize
        elsif @first_name.present? && @last_name.present?
          person = university.people
                             .where(first_name: @first_name, last_name: @last_name)
                             .first_or_initialize
        end
        person.first_name = @first_name
        person.last_name = @last_name
        # person.gender = @gender
        # person.birth = @birth
        person.email = @mail
        person.url = @url
        # person.phone_professional = @phone_professional
        # person.phone_personal = @phone_personal
        person.phone = @mobile
        # person.address = @address
        # person.zipcode = @zipcode
        # person.city = @city
        # person.country = @country
        person.biography = @biography
        person.twitter = @social_twitter
        person.linkedin = @social_linkedin
        person.is_alumnus = true
        person.slug = person.to_s.parameterize.dasherize
        person
    end

    def organization
      unless @organization
        @organization = University::Organization.where(university_id: @university.id, name: organization_name).first_or_initialize
        @organization.long_name = @long_name
        @organization.kind = @kind.to_sym
        @organization.siren = @siren
        @organization.nic = @nic
        @organization.description = @description
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

    def clean_encoding(value)
      return if value.nil?
      if value.encoding != 'UTF-8'
        value = value.force_encoding 'UTF-8'
      end
      value.strip
    end
  end
end
