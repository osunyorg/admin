# == Schema Information
#
# Table name: education_programs
#
#  id                 :uuid             not null, primary key
#  capacity           :integer
#  continuing         :boolean
#  description        :text
#  ects               :integer
#  featured_image_alt :string
#  level              :integer
#  name               :string
#  path               :string
#  position           :integer          default(0)
#  published          :boolean          default(FALSE)
#  slug               :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  parent_id          :uuid
#  university_id      :uuid             not null
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
  include WithGit
  include WithFeaturedImage
  include WithBlobs
  include WithMenuItemTarget
  include WithSlug
  include WithTree
  include WithInheritance
  include WithPosition

  rich_text_areas_with_inheritance  :accessibility,
                                    :contacts,
                                    :duration,
                                    :evaluation,
                                    :objectives,
                                    :opportunities,
                                    :other,
                                    :pedagogy,
                                    :prerequisites,
                                    :pricing,
                                    :registration,
                                    :content,
                                    :results

  attr_accessor :skip_websites_categories_callback

  belongs_to :university
  belongs_to :parent,
             class_name: 'Education::Program',
             optional: true
  has_many   :children,
             class_name: 'Education::Program',
             foreign_key: :parent_id,
             dependent: :destroy
  has_many   :teachers,
             class_name: 'Education::Program::Teacher',
             dependent: :destroy
  has_many   :university_people_through_teachers,
             through: :teachers,
             source: :person
  has_many   :roles,
             class_name: 'Education::Program::Role',
             dependent: :destroy
  has_many   :role_people,
             through: :roles,
             source: :people
  has_many   :university_people_through_roles,
             through: :role_people,
             source: :person
  has_many   :website_categories,
             class_name: 'Communication::Website::Category',
             dependent: :destroy
  has_and_belongs_to_many :schools,
                          class_name: 'Education::School',
                          join_table: 'education_programs_schools',
                          foreign_key: 'education_program_id',
                          association_foreign_key: 'education_school_id'
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

  after_save :update_children_paths, if: :saved_change_to_path?
  after_save_commit :set_websites_categories, unless: :skip_websites_categories_callback

  scope :published, -> { where(published: true) }

  def to_s
    "#{name}"
  end

  def best_featured_image(fallback: true)
    return featured_image if featured_image.attached?
    best_image = parent&.best_featured_image(fallback: false)
    best_image ||= featured_image if fallback
    best_image
  end

  def git_path(website)
    "content/programs/#{path}/_index.html"
  end

  def git_dependencies(website)
    [self] +
    active_storage_blobs +
    university_people_through_teachers +
    university_people_through_teachers.map(&:teacher) +
    university_people_through_roles
    # TODO: les administrative via roles
  end

  def git_destroy_dependencies(website)
    [self] +
    explicit_active_storage_blobs
  end

  def update_children_paths
    children.each do |child|
      child.update_column :path, child.generated_path
      child.update_children_paths
    end
  end

  def set_websites_categories
    websites.find_each(&:set_programs_categories!)
  end

  protected

  def last_ordered_element
    university.education_programs.where(parent_id: parent_id).ordered.last
  end

  def explicit_blob_ids
    super.concat [featured_image&.blob_id]
  end

  def inherited_blob_ids
    [best_featured_image&.blob_id]
  end
end
