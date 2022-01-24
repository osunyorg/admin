# == Schema Information
#
# Table name: university_person_involvements
#
#  id            :uuid             not null, primary key
#  description   :text
#  kind          :integer
#  position      :integer
#  target_type   :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  person_id     :uuid             not null
#  target_id     :uuid             not null
#  university_id :uuid             not null
#
# Indexes
#
#  index_university_person_involvements_on_person_id      (person_id)
#  index_university_person_involvements_on_target         (target_type,target_id)
#  index_university_person_involvements_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_...  (person_id => university_people.id)
#  fk_rails_...  (university_id => universities.id)
#
class University::Person::Involvement < ApplicationRecord
  belongs_to :university
  belongs_to :person
  belongs_to :target, polymorphic: true

  enum kind: { administrator: 10, researcher: 20, teacher: 30 }
end
