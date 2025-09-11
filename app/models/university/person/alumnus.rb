# == Schema Information
#
# Table name: university_people
#
#  id                            :uuid             not null, primary key
#  address                       :string
#  address_visibility            :integer          default("private")
#  birthdate                     :date
#  bodyclass                     :string
#  city                          :string
#  country                       :string
#  email                         :string
#  email_visibility              :integer          default("private")
#  gender                        :integer
#  habilitation                  :boolean          default(FALSE)
#  is_administration             :boolean
#  is_alumnus                    :boolean          default(FALSE)
#  is_author                     :boolean
#  is_researcher                 :boolean
#  is_teacher                    :boolean
#  linkedin_visibility           :integer          default("private")
#  mastodon_visibility           :integer          default("private")
#  phone_mobile                  :string
#  phone_mobile_visibility       :integer          default("private")
#  phone_personal                :string
#  phone_personal_visibility     :integer          default("private")
#  phone_professional            :string
#  phone_professional_visibility :integer          default("private")
#  tenure                        :boolean          default(FALSE)
#  twitter_visibility            :integer          default("private")
#  zipcode                       :string
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  created_by_id                 :uuid             indexed
#  university_id                 :uuid             not null, indexed
#  user_id                       :uuid             indexed
#
# Indexes
#
#  index_university_people_on_created_by_id  (created_by_id)
#  index_university_people_on_university_id  (university_id)
#  index_university_people_on_user_id        (user_id)
#
# Foreign Keys
#
#  fk_rails_6e77b14f8b  (created_by_id => users.id)
#  fk_rails_b47a769440  (user_id => users.id)
#  fk_rails_da35e70d61  (university_id => universities.id)
#
class University::Person::Alumnus < University::Person
  def self.polymorphic_name
    'University::Person::Alumnus'
  end

  # No alumni on websites, we use people
  def can_have_git_file?
    false
  end

  def template_static
    "admin/university/people/alumni/static"
  end

end
