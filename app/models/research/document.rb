# == Schema Information
#
# Table name: research_documents
#
#  id                   :uuid             not null, primary key
#  data                 :jsonb
#  docid                :string
#  hal_url              :string
#  ref                  :string
#  title                :string
#  url                  :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  university_id        :uuid             not null, indexed
#  university_person_id :uuid             not null, indexed
#
# Indexes
#
#  index_research_documents_on_university_id         (university_id)
#  index_research_documents_on_university_person_id  (university_person_id)
#
# Foreign Keys
#
#  fk_rails_03e727a207  (university_person_id => university_people.id)
#  fk_rails_ceb4d1344f  (university_id => universities.id)
#
class Research::Document < ApplicationRecord
  include WithUniversity

  belongs_to :person, class_name: 'University::Person', foreign_key: :university_person_id

  def doi_url
    return unless doi.present?
    "http://dx.doi.org/#{doi}"
  end

  def to_s
    "#{title}"
  end
end
