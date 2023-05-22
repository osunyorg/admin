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
#  duration              :text
#  evaluation            :text
#  featured_image_alt    :string
#  featured_image_credit :text
#  initial               :boolean
#  meta_description      :text
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
#  summary               :text
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
  include AsIndirectObject
  include Sanitizable
  include WithAccessibility
  include WithAlumni
  include WithBlobs
  include WithBlocks
  include WithDiploma
  include WithFeaturedImage
  include WithGitFiles
  include WithInheritance
  include WithMenuItemTarget
  include WithPermalink
  include WithPosition
  include WithSchools
  include WithSlug
  include WithTeam
  include WithTree
  include WithUniversity
  include WithWebsitesCategories

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

  has_summernote :presentation

  belongs_to :parent,
             class_name: 'Education::Program',
             optional: true

  has_many   :children,
             class_name: 'Education::Program',
             foreign_key: :parent_id,
             dependent: :destroy

  has_one_attached_deletable :downloadable_summary

  validates_presence_of :name
  validates :downloadable_summary, size: { less_than: 50.megabytes }

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

  def to_short_s
    short_name.blank? ? to_s : short_name
  end

  def to_s
    "#{name}"
  end

  def best_featured_image_source(fallback: true)
    return self if featured_image.attached?
    best_source = parent&.best_featured_image_source(fallback: false)
    best_source ||= self if fallback
    best_source
  end

  def git_path(website)
    return unless published? && for_website?(website)
    clean_path = Static.clean_path "#{git_path_content_prefix(website)}programs/#{path}/"
    "#{clean_path}_index.html"
  end

  def dependencies
    active_storage_blobs +
    blocks +
    university_people_through_involvements.map(&:teacher) +
    university_people_through_role_involvements.map(&:administrator) +
    [diploma]
  end

  def references
    references = schools + siblings + descendants
    references << parent if parent.present?
    references
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

  def has_research_papers?
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
    super.concat [featured_image&.blob_id, downloadable_summary&.blob_id]
  end

  def inherited_blob_ids
    [best_featured_image&.blob_id]
  end
end
