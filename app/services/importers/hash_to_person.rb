module Importers
  class HashToPerson
    def initialize(university, hash)
      @university = university
      @hash = hash
      @error = nil
      extract_person_variables
      if valid?
        person.save
        add_picture_if_possible!(person)
      end
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

    def person
      @person ||= build_person
    end

    protected

    def extract_person_variables
      @first_name = @hash[0].to_s.strip
      @last_name = @hash[1].to_s.strip
      @gender = @hash[2].to_s.strip
      @birth = @hash[3].to_s.strip
      @email = @hash[4].to_s.strip
      @photo = @hash[5].to_s.strip
      @url = @hash[6].to_s.strip
      @phone_professional = @hash[7].to_s.strip
      @phone_personal = @hash[8].to_s.strip
      @mobile = @hash[9].to_s.strip
      @address = @hash[10].to_s.strip
      @zipcode = @hash[11].to_s.strip
      @city = @hash[12].to_s.strip
      @country = @hash[13].to_s.strip
      @biography = @hash[14].to_s.strip
      @social_twitter = @hash[15].to_s.strip
      @social_linkedin = @hash[16].to_s.strip
    end

    def build_person
      if @email.present?
        person = @university.people
                           .where(email: @email)
                           .first_or_initialize
      elsif @first_name.present? && @last_name.present?
        person = @university.people
                           .where(first_name: @first_name, last_name: @last_name)
                           .first_or_initialize
      end
      person.first_name = @first_name
      person.last_name = @last_name
      person.gender = gender
      person.birthdate = @birth
      person.email = @email
      person.url = @url
      person.phone_professional = @phone_professional
      person.phone_personal = @phone_personal
      person.phone_mobile = @mobile
      person.address = @address
      person.zipcode = @zipcode
      person.city = @city
      person.country = @country
      person.biography = @biography
      person.twitter = @social_twitter
      person.linkedin = @social_linkedin
      person.slug = person.to_s.parameterize.dasherize
      person.language_id = @university.default_language_id
      person
    end

    def country_not_found?
      ISO3166::Country[@country].nil?
    end

    def gender
      case @gender
        when 'm'
          :male
        when 'f'
          :female
        when 'n'
          :non_binary
        else
          nil
      end
    end

    def add_picture_if_possible!(person)
      return if @photo.nil?
      return if @person.picture.attached?
      return unless @photo.end_with?('.jpg') || @photo.end_with?('.png') || @photo.end_with?('.svg')
      begin
        file = URI.open @photo
        filename = File.basename @photo
        person.picture.attach(io: file, filename: filename)
      rescue
      end
    end

  end
end
