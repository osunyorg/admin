# == Schema Information
#
# Table name: education_programs
#
#  id            :uuid             not null, primary key
#  capacity      :integer
#  continuing    :boolean
#  ects          :integer
#  level         :integer
#  name          :string
#  path          :string
#  position      :integer          default(0)
#  slug          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  parent_id     :uuid
#  university_id :uuid             not null
#
# Indexes
#
#  index_education_programs_on_parent_id      (parent_id)
#  index_education_programs_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_...  (parent_id => education_programs.id)
#  fk_rails_...  (university_id => universities.id)
#
class Education::Program < ApplicationRecord
  include WithGithubFiles
  include WithTree

  attr_accessor :skip_websites_categories_callback

  has_rich_text :accessibility
  has_rich_text :contacts
  has_rich_text :duration
  has_rich_text :evaluation
  has_rich_text :objectives
  has_rich_text :opportunities
  has_rich_text :other
  has_rich_text :pedagogy
  has_rich_text :prerequisites
  has_rich_text :pricing
  has_rich_text :registration

  belongs_to :university
  belongs_to :parent,
             class_name: 'Education::Program',
             optional: true
  has_many   :children,
             class_name: 'Education::Program',
             foreign_key: :parent_id,
             dependent: :nullify
  has_and_belongs_to_many :schools,
                          class_name: 'Education::School',
                          join_table: 'education_programs_schools',
                          foreign_key: 'education_program_id',
                          association_foreign_key: 'education_school_id'
  has_and_belongs_to_many :teachers,
                          class_name: 'Administration::Member',
                          join_table: 'education_programs_teachers',
                          foreign_key: 'education_program_id',
                          association_foreign_key: 'education_teacher_id'
  has_many :websites, -> { distinct }, through: :schools

  enum level: {
    first_year: 100,
    second_year: 200,
    dut: 210,
    bachelor: 300,
    master: 500,
    doctor: 800
  }

  validates_presence_of :name

  before_validation :make_path
  after_save :update_children_paths, if: :saved_change_to_path?
  after_save_commit :set_websites_categories, unless: :skip_websites_categories_callback

  scope :ordered, -> { order(:position) }

  def to_s
    "#{name}"
  end

  # Override from WithGithubFiles
  def github_path_generated
    "_programs/#{path}/index.html".gsub(/\/+/, '/')
  end

  def make_path
    self.path = "#{parent&.path}/#{slug}".gsub(/\/+/, '/')
  end

  def list_of_other_programs
    university.list_of_programs.reject! { |p| p[:id] == id }
  end

  def set_websites_categories
    websites.find_each(&:set_programs_categories!)
  end
end
