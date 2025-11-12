# == Schema Information
#
# Table name: university_person_localizations
#
#  id                    :uuid             not null, primary key
#  biography             :text
#  deleted_at            :datetime
#  featured_image_alt    :text
#  featured_image_credit :text
#  first_name            :string
#  last_name             :string
#  linkedin              :string
#  mastodon              :string
#  meta_description      :text
#  name                  :string
#  picture_credit        :text
#  slug                  :string           indexed
#  summary               :text
#  twitter               :string
#  url                   :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  about_id              :uuid             uniquely indexed => [language_id], indexed
#  language_id           :uuid             uniquely indexed => [about_id], indexed
#  university_id         :uuid             indexed
#
# Indexes
#
#  idx_on_about_id_language_id_54757d0dad                  (about_id,language_id) UNIQUE
#  index_university_person_localizations_on_about_id       (about_id)
#  index_university_person_localizations_on_language_id    (language_id)
#  index_university_person_localizations_on_slug           (slug)
#  index_university_person_localizations_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_469b2f6a6f  (about_id => university_people.id)
#  fk_rails_5eca3fe920  (university_id => universities.id)
#  fk_rails_bf16824595  (language_id => languages.id)
#
class University::Person::Localization::Teacher < University::Person::Localization

  def self.polymorphic_name
    'University::Person::Localization::Teacher'
  end

  def git_path_relative
    "teachers/#{slug}/_index.html"
  end

  def template_static
    "admin/education/teachers/static"
  end

  def dependencies
    [
      person_l10n,
      person
    ]
  end

  def references
    person.education_programs_as_teacher
  end

  def static_localization_key
    # so we don't mess with the University::Person::Localization static_localization_key
    "#{about.class.polymorphic_name.parameterize}-teacher-#{self.about_id}"
  end

end
