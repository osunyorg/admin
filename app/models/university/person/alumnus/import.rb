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
      # program
      # year
      # first_name
      # last_name
      # gender
      # birth
      # mail
      # photo
      # url
      # phonepro
      # phoneperso
      # mobile
      # address
      # zipcode
      # city
      # country
      # status
      # socialtwitter
      # sociallinkedin
      # row['program'] = '23279cab-8bc1-4c75-bcd8-1fccaa03ad55' #TMP local fix
      program = university.education_programs
                          .find_by(id: row['program'])
      next if program.nil?
      academic_year = university.academic_years
                                .where(year: row['year'])
                                .first_or_create

      cohort = university.education_cohorts
                         .where(program: program, academic_year: academic_year)
                         .first_or_create
      first_name = clean_encoding row['first_name']
      last_name = clean_encoding row['last_name']
      email = clean_encoding(row['mail']).to_s.downcase
      url = clean_encoding row['url']
      if email.present?
        person = university.people
                           .where(email: email)
                           .first_or_create
        person.first_name = first_name
        person.last_name = last_name
      else
        person = university.people
                           .where(first_name: first_name, last_name: last_name)
                           .first_or_create
      end
      # TODO all fields
      person.is_alumnus = true
      person.url = url
      person.slug = person.to_s.parameterize.dasherize
      person.twitter = row['socialtwitter']
      person.linkedin = row['sociallinkedin']
      byebug unless person.valid?
      person.save
      cohort.people << person unless person.in?(cohort.people)
      photo = row['photo'].to_s
      if photo.end_with?('.jpg') || photo.end_with?('.png')
        filename = File.basename photo
        begin
          file = URI.open photo
          person.picture.attach(io: file, filename: 'some-image.jpg')
        rescue
        end
      end
    end
  end

  def clean_encoding(value)
    return if value.nil?
    if value.encoding != 'UTF-8'
      value = value.force_encoding 'UTF-8'
    end
    value.strip
  end
end
