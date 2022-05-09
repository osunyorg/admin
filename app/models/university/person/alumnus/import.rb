# == Schema Information
#
# Table name: university_person_alumnus_imports
#
#  id            :uuid             not null, primary key
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  university_id :uuid             not null, indexed
#  user_id       :uuid             not null, indexed
#
# Indexes
#
#  index_university_person_alumnus_imports_on_university_id  (university_id)
#  index_university_person_alumnus_imports_on_user_id        (user_id)
#
# Foreign Keys
#
#  fk_rails_3ff74ac195  (user_id => users.id)
#  fk_rails_d14eb003f9  (university_id => universities.id)
#
class University::Person::Alumnus::Import < ApplicationRecord
  include WithUniversity
  include Importable

  def self.table_name
    'university_person_alumnus_imports'
  end

  protected

  def parse
    csv.each do |row|
      person = import_person row
      next unless person
      import_cohort row, person
      organization = import_organization row
      next unless organization
      import_experience row, person, organization
    end
  end

  def import_person(row)
    first_name = clean_encoding row['first_name']
    last_name = clean_encoding row['last_name']
    email = clean_encoding(row['mail']).to_s.downcase
    return if first_name.blank? && last_name.blank? && email.blank?
    url = clean_encoding row['url']
    if email.present?
      person = university.people
                         .where(email: email)
                         .first_or_create
      person.first_name = first_name
      person.last_name = last_name
    elsif first_name.present? && last_name.present?
      person = university.people
                         .where(first_name: first_name, last_name: last_name)
                         .first_or_create
    end
    return if person.nil?
    # TODO all fields
    # gender
    # birth
    # address
    # zipcode
    # city
    # country
    person.is_alumnus = true
    person.url = url
    person.slug = person.to_s.parameterize.dasherize
    person.twitter ||= row['social_twitter']
    person.linkedin ||= row['social_linkedin']
    person.biography ||= clean_encoding row['biography']
    person.phone ||= row['mobile']
    person.phone ||= row['phone_personal']
    person.phone ||= row['phone_professional']
    byebug unless person.valid?
    person.save
    add_picture person, row['photo']
    person
  end

  def import_cohort(row, person)
    program = program_with_id row['program']
    return if program.nil?
    academic_year = university.academic_years
                              .where(year: row['year'])
                              .first_or_create
    cohort = university.education_cohorts
                       .where(program: program, academic_year: academic_year)
                       .first_or_create
    person.add_to_cohort cohort
  end

  def import_organization(row)
    name = clean_encoding row['company_name']
    siren = clean_encoding row['company_siren']
    nic = clean_encoding row['company_nic']
    return if name.blank?
    if !siren.blank? && !nic.blank?
      organization = university.organizations
                               .find_by siren: siren,
                                        nic: nic
    elsif !siren.blank?
      organization ||= university.organizations
                               .find_by siren: siren
    end
    organization ||= university.organizations
                               .find_by name: name
    organization ||= university.organizations
                               .where( name: name,
                                       siren: siren,
                                       nic: nic)
                               .first_or_create
    organization
  end

  def import_experience(row, person, organization)
    job = row['experience_job']
    from = row['experience_from']
    to = row['experience_to']
    experience = person.experiences
                       .where(university: university,
                              organization: organization,
                              from_year: from)
                       .first_or_create
    experience.description = job
    experience.to_year = to
    experience.save
    experience
  end

  def add_picture(person, photo)
    return if photo.nil?
    return if person.picture.attached?
    return unless photo.end_with?('.jpg') || photo.end_with?('.png')
    begin
      file = URI.open photo
      filename = File.basename photo
      person.picture.attach(io: file, filename: filename)
    rescue
    end
  end

  def program_with_id(id)
    if Rails.env.development?
      # substitute local data for testing
      substitutes = {
        # Arnaud
        'c6b78fac-0a5f-4c44-ad22-4ee68ed382bb' => '23279cab-8bc1-4c75-bcd8-1fccaa03ad55', # DUT MMI
        'ae3e067a-63b4-4c3f-ba9c-468ade0e4182' => '863b8c9c-1ed1-4af7-b92c-7264dfb6b4da', # MASTER IJBA
        'f4d4a92f-8b8f-4778-a127-9293684666be' => '8dfaee2a-c876-4b1c-8e4e-8380d720c71f', # DU_BILINGUE
        '6df53074-195c-4299-8b49-bbc9d7cad41a' => 'be3cb0b2-7f66-4c5f-b8d7-6a39a0480c46', # DU_JRI
        '0d81d3a2-a12c-4326-a395-fd0df4a3ea4f' => '56a50383-3ef7-43f6-8e98-daf279e86802' # DUT_JOURNALISME
        # Alex
        # 'c6b78fac-0a5f-4c44-ad22-4ee68ed382bb' => '02e6f703-d15b-4841-ac95-3c47d88e21b5', # DUT MMI
        # 'ae3e067a-63b4-4c3f-ba9c-468ade0e4182' => '8fdfafb7-11fd-456c-9f47-7fd76dddb373', # MASTER IJBA
        # 'f4d4a92f-8b8f-4778-a127-9293684666be' => 'fab9b86c-8872-4df5-9a97-0e30b104a837', # DU_BILINGUE
        # '6df53074-195c-4299-8b49-bbc9d7cad41a' => 'cb1a26b9-fe5c-4ad1-9715-71cec4642910', # DU_JRI
        # '0d81d3a2-a12c-4326-a395-fd0df4a3ea4f' => '91c44fd2-f0a4-4189-a3f5-311322b7b472' # DUT_JOURNALISME
        # Sebou
        # 'c6b78fac-0a5f-4c44-ad22-4ee68ed382bb' => 'ea5d32be-b86a-4257-984a-4d84717dd1d6', # DUT MMI
        # 'ae3e067a-63b4-4c3f-ba9c-468ade0e4182' => '701c3a4f-3585-4152-b866-da17f4e80e77', # MASTER IJBA
        # 'f4d4a92f-8b8f-4778-a127-9293684666be' => '0c05b690-ebd1-4efa-862c-81ea0978fb0b', # DU_BILINGUE
        # '6df53074-195c-4299-8b49-bbc9d7cad41a' => '4ded6dfa-2fab-4e77-b58d-0d97344a04d1', # DU_JRI
        # '0d81d3a2-a12c-4326-a395-fd0df4a3ea4f' => '4edac5cd-6564-4e47-a18c-960d3e5de54e' # DUT_JOURNALISME
      }
      id = substitutes[id] if substitutes.has_key? id
    end
    university.education_programs.find_by(id: id)
  end

  def clean_encoding(value)
    return if value.nil?
    if value.encoding != 'UTF-8'
      value = value.force_encoding 'UTF-8'
    end
    value.strip
  end
end
