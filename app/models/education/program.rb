# == Schema Information
#
# Table name: education_programs
#
#  id                    :uuid             not null, primary key
#  accessibility         :text
#  apprenticeship        :boolean
#  capacity              :integer
#  contacts              :text
#  content               :text
#  continuing            :boolean
#  description           :text
#  duration              :text
#  evaluation            :text
#  featured_image_alt    :string
#  featured_image_credit :text
#  initial               :boolean
#  level                 :integer
#  name                  :string
#  objectives            :text
#  opportunities         :text
#  other                 :text
#  path                  :string
#  pedagogy              :text
#  position              :integer          default(0)
#  prerequisites         :text
#  presentation          :text
#  pricing               :text
#  published             :boolean          default(FALSE)
#  registration          :text
#  registration_url      :string
#  results               :text
#  short_name            :string
#  slug                  :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  diploma_id            :uuid             indexed
#  parent_id             :uuid             indexed
#  university_id         :uuid             not null, indexed
#
# Indexes
#
#  index_education_programs_on_diploma_id     (diploma_id)
#  index_education_programs_on_parent_id      (parent_id)
#  index_education_programs_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_08b351087c  (university_id => universities.id)
#  fk_rails_ec1f16f607  (parent_id => education_programs.id)
#
class Education::Program < ApplicationRecord
  include Aboutable
  include Sanitizable
  include WithUniversity
  include WithGit
  include WithFeaturedImage
  include WithBlobs
  include WithMenuItemTarget
  include WithSlug
  include WithTree
  include WithInheritance
  include WithPosition
  include WithBlocks
  include WithSchools
  include WithDiploma
  include WithAlumni
  include WithWebsites
  include WithTeam

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

  belongs_to :parent,
             class_name: 'Education::Program',
             optional: true

  has_many   :children,
             class_name: 'Education::Program',
             foreign_key: :parent_id,
             dependent: :destroy

  # Deprecated, now in diploma
  enum level: {
    not_applicable: 0,
    primary: 40,
    secondary: 60,
    high: 80,
    first_year: 100,
    second_year: 200,
    dut: 210,
    bachelor: 300,
    master: 500,
    doctor: 800
  }

  validates_presence_of :name

  after_save :update_children_paths, if: :saved_change_to_path?

  scope :published, -> { where(published: true) }
  scope :ordered_by_name, -> { order(:name) }
  scope :for_search_term, -> (term) {
    where("
      unaccent(education_programs.name) ILIKE unaccent(:term)
    ", term: "%#{sanitize_sql_like(term)}%")
  }
  scope :for_diploma, -> (diploma_id) {
    where(diploma_id: diploma_id)
  }
  scope :for_school, -> (school_id) {
    joins(:schools)
      .where(education_schools: { id: school_id })
      .distinct
  }
  scope :for_publication, -> (publication) {
    where(published: publication)
  }

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

  def path_in_website(website)
    "#{website.special_page(:education_programs).path}#{path}".gsub('//', '/')
  end

  def git_dependencies(website)
    [self] +
    active_storage_blobs +
    git_block_dependencies +
    university_people_through_involvements +
    university_people_through_involvements.map(&:active_storage_blobs).flatten +
    university_people_through_involvements.map(&:teacher) +
    university_people_through_role_involvements +
    university_people_through_role_involvements.map(&:active_storage_blobs).flatten +
    university_people_through_role_involvements.map(&:administrator) +
    website.menus +
    [diploma]
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

  #####################
  # Aboutable methods #
  #####################
  def has_administrators?
    university_people_through_role_involvements.any? ||
    descendants.any? { |descendant| descendant.university_people_through_role_involvements.any? }
  end

  def has_researchers?
    false
  end

  def has_teachers?
    university_people_through_involvements.any? ||
    descendants.any? { |descendant| descendant.university_people_through_involvements.any? }
  end

  def has_education_programs?
    published? || descendants.any?(&:published?)
  end

  def has_education_diplomas?
    diploma.present? || descendants.any? { |descendant| descendant.diploma.present? }
  end

  def has_research_articles?
    false
  end

  def has_research_volumes?
    false
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
