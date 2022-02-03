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
  include WithPosition

  enum kind: { administrator: 10, researcher: 20, teacher: 30 }

  belongs_to :university
  belongs_to :person, class_name: 'University::Person'
  belongs_to :target, polymorphic: true

  validates :person_id, uniqueness: { scope: [:target_id, :target_type] }
  validates :target_id, uniqueness: { scope: [:person_id, :target_type] }

  before_validation :set_kind, on: :create
  before_validation :set_university_id, on: :create
  after_commit :sync_with_git

  scope :ordered_by_name, -> {
    joins(:person).select('university_person_involvements.*')
                  .order('university_people.last_name', 'university_people.first_name')
  }

  def to_s
    "#{person}"
  end

  def sync_with_git
    target.sync_with_git if target.respond_to? :sync_with_git
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
    else
      self.kind = :administrator
    end
  end

  def set_university_id
    self.university_id = self.person.university_id
  end
end
