# == Schema Information
#
# Table name: university_people
#
#  id                :uuid             not null, primary key
#  description       :text
#  email             :string
#  first_name        :string
#  is_administration :boolean
#  is_researcher     :boolean
#  is_teacher        :boolean
#  last_name         :string
#  phone             :string
#  slug              :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  university_id     :uuid             not null
#  user_id           :uuid
#
# Indexes
#
#  index_university_people_on_university_id  (university_id)
#  index_university_people_on_user_id        (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (university_id => universities.id)
#  fk_rails_...  (user_id => users.id)
#
class University::Person::Teacher < University::Person
  def self.polymorphic_name
    'University::Person::Teacher'
  end

  def git_path(website)
    "content/teachers/#{slug}/_index.html" if for_website?(website)
  end

  def for_website?(website)
    is_teacher && website.about_school? && website.programs
                                                  .published
                                                  .joins(:teachers)
                                                  .where(education_program_teachers: { person_id: id })
                                                  .any?
  end
end
