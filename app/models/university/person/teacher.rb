# == Schema Information
#
# Table name: university_people
#
#  id                :uuid             not null, primary key
#  biography         :text
#  description       :text
#  email             :string
#  first_name        :string
#  habilitation      :boolean          default(FALSE)
#  is_administration :boolean
#  is_researcher     :boolean
#  is_teacher        :boolean
#  last_name         :string
#  phone             :string
#  slug              :string
#  tenure            :boolean          default(FALSE)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  university_id     :uuid             not null, indexed
#  user_id           :uuid             indexed
#
# Indexes
#
#  index_university_people_on_university_id  (university_id)
#  index_university_people_on_user_id        (user_id)
#
# Foreign Keys
#
#  fk_rails_b47a769440  (user_id => users.id)
#  fk_rails_da35e70d61  (university_id => universities.id)
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
                                                  .joins(:university_person_involvements)
                                                  .where(university_person_involvements: { person_id: id })
                                                  .any?
  end
end
