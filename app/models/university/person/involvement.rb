# == Schema Information
#
# Table name: university_person_involvements
#
#  id            :uuid             not null, primary key
#  description   :text
#  kind          :integer
#  position      :integer
#  target_type   :string           not null, indexed => [target_id]
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  language_id   :uuid             indexed
#  original_id   :uuid             indexed
#  person_id     :uuid             not null, indexed
#  target_id     :uuid             not null, indexed => [target_type]
#  university_id :uuid             not null, indexed
#
# Indexes
#
#  index_university_person_involvements_on_language_id    (language_id)
#  index_university_person_involvements_on_original_id    (original_id)
#  index_university_person_involvements_on_person_id      (person_id)
#  index_university_person_involvements_on_target         (target_type,target_id)
#  index_university_person_involvements_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_0e1e65ddb0  (original_id => university_person_involvements.id)
#  fk_rails_3df2a6f2d9  (language_id => languages.id)
#  fk_rails_407e2a671c  (person_id => university_people.id)
#  fk_rails_5c704f6338  (university_id => universities.id)
#
class University::Person::Involvement < ApplicationRecord
  include Localizable
  include WithPosition
  include WithUniversity

  enum kind: { 
    administrator: 10, 
    researcher: 20, 
    teacher: 30 
  }

  belongs_to :person, class_name: 'University::Person'
  # Can be an Education::Program, a Research::Laboratory, or a University::Role (attached to Programs or Schools)
  belongs_to :target, polymorphic: true

  validates :person_id, uniqueness: { scope: [:target_id, :target_type] }
  validates :target_id, uniqueness: { scope: [:person_id, :target_type] }

  before_validation :set_kind,
                    :set_university_id,
                    on: :create

  scope :ordered_by_name, -> {
    joins(:person).select('university_person_involvements.*')
                  .order('university_people.last_name', 'university_people.first_name')
  }
  scope :ordered_by_date, -> { order(:created_at) }

  def to_s_in(language)
    "#{person.to_s_in(language)}"
  end

  protected

  def last_ordered_element
    self.class.unscoped.where(university_id: university_id, target: target).ordered.last
  end

  def set_kind
    case target_type
    when "Education::Program"
      self.kind = :teacher
    when "Research::Laboratory"
      self.kind = :researcher
    else # University::Role (attached to Programs or Schools)
      self.kind = :administrator
    end
  end

  def set_university_id
    self.university_id = person.university_id
  end

end
