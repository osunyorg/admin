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
      row['program'] = '23279cab-8bc1-4c75-bcd8-1fccaa03ad55' #TMP local fix
      program = university.education_programs
                          .find_by(id: row['program'])
      next if program.nil?
      year = university.academic_years
                       .where(year: row['year'])
                       .first_or_create
      if row['mail'].blank?
        person = university.people
                           .where(first_name: row['first_name'], last_name: row['last_name'])
                           .first_or_create
      else
        person = university.people
                           .where(email: row['mail'])
                           .first_or_create
        person.first_name = row['first_name']
        person.last_name = row['last_name']
      end
      # TODO all fields
      person.is_alumnus = true
      person.url = row['url']
      person.slug = person.to_s.parameterize
      person.save
      # byebug
    end
  end
end
