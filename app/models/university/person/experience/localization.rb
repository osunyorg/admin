# == Schema Information
#
# Table name: university_person_experience_localizations
#
#  id            :uuid             not null, primary key
#  description   :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  about_id      :uuid             uniquely indexed => [language_id], indexed
#  language_id   :uuid             uniquely indexed => [about_id], indexed
#  university_id :uuid             indexed
#
# Indexes
#
#  idx_on_about_id_language_id_6610a91469                        (about_id,language_id) UNIQUE
#  idx_on_language_id_61a5fb5403                                 (language_id)
#  idx_on_university_id_1be9c668d5                               (university_id)
#  index_university_person_experience_localizations_on_about_id  (about_id)
#
# Foreign Keys
#
#  fk_rails_8a78370481  (language_id => languages.id)
#  fk_rails_981e6d6bf6  (about_id => university_person_experiences.id)
#  fk_rails_eb7a946347  (university_id => universities.id)
#
class University::Person::Experience::Localization < ApplicationRecord
  include AsLocalization
  include Sanitizable
  include WithUniversity

  def to_s
    description
  end

end
