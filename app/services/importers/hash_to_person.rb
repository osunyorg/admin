module Importers
  class HashToPerson

    NUMBER_OF_COLUMNS = 19

    def initialize(university, language, hash)
      @university = university
      @language = language
      @hash = hash
      @error = nil
      extract_person_variables
      if valid?
        person.save
        add_picture_if_possible!(person)
      end
    end

    def valid?
      if @first_name.blank? && @last_name.blank? && @email.blank?
        @error = "An email or a name is necessary"
      elsif country_not_found?
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
      @social_mastodon = @hash[17].to_s.strip
      @category_names = @hash[18].to_s.split('|').map { |e| e.strip }
    end

    def build_person
      if @email.present?
        person = find_person_with_email
      elsif @first_name.present? && @last_name.present?
        person = find_person_with_name_in_current_language
        person ||= find_person_with_name_in_another_language
      else
        # No mail, no name, nothing
        return
      end
      person ||= @university.people.new
      localization_id = person.localizations.find_by(language_id: @language.id)&.id
      person.gender = gender
      person.birthdate = @birth
      person.email = @email
      person.phone_professional = @phone_professional
      person.phone_personal = @phone_personal
      person.phone_mobile = @mobile
      person.address = @address
      person.zipcode = @zipcode
      person.city = @city
      person.country = @country
      person.localizations_attributes = [
        {
          id: localization_id, language_id: @language.id,
          biography: @biography, first_name: @first_name, last_name: @last_name,
          linkedin: @social_linkedin, mastodon: @social_mastodon, twitter: @social_twitter,
          url: @url
        }
      ]
      person.categories = categories
      person
    end

    def find_person_with_email
      @university.people.find_by(email: @email)
    end

    def find_person_with_name_in_current_language
      @university.people
        .joins(:localizations)
        .where(university_person_localizations: {
          language_id: @language.id,
          first_name: @first_name, last_name: @last_name
        })
        .first
    end

    def find_person_with_name_in_another_language
      @university.people
        .joins(:localizations)
        .where.not(university_person_localizations: {
          language_id: @language.id
        })
        .where(university_person_localizations: {
          first_name: @first_name, last_name: @last_name
        })
        .first
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

    def categories
      @category_names.map do |category_name|
        category_localization = University::Person::Category::Localization.find_by(university_id: @university.id, language_id: @language.id, name: category_name)
        if category_localization.present?
          category_localization.about
        else
          category = @university.person_categories.create(localizations_attributes: [ { name: category_name, language_id: @language.id }])
          category
        end
      end
    end

    def add_picture_if_possible!(person)
      return if @photo.nil?
      return if person.picture.attached?
      return unless @photo.end_with?(*Rails.application.config.default_images_formats)
      begin
        file = URI.parse(@photo).open
        filename = File.basename(@photo)
        person.picture.attach(io: file, filename: filename)
      rescue
      end
    end

  end
end
