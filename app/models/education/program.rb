# == Schema Information
#
# Table name: education_programs
#
#  id                 :uuid             not null, primary key
#  apprenticeship     :boolean
#  bodyclass          :string
#  capacity           :integer
#  continuing         :boolean
#  initial            :boolean
#  position           :integer          default(0)
#  qualiopi_certified :boolean          default(FALSE)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  diploma_id         :uuid             indexed
#  parent_id          :uuid             indexed
#  university_id      :uuid             not null, indexed
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
  include AsIndirectObject
  include Filterable
  include Localizable
  include Sanitizable
  include WebsitesLinkable
  include WithAlumni
  include WithDiploma
  include WithLocations
  include WithMenuItemTarget
  include WithPosition
  include WithSchools
  include WithTeam
  include WithTree
  include WithUniversity
  include WithWebsitesCategories

  belongs_to :parent,
             class_name: 'Education::Program',
             optional: true

  has_many   :children,
             class_name: 'Education::Program',
             foreign_key: :parent_id

  has_and_belongs_to_many :categories,
                          class_name: 'Education::Program::Category',
                          join_table: :education_program_categories_programs,
                          foreign_key: :education_program_id,
                          association_foreign_key: :education_program_category_id

  before_destroy :move_children

  # can't use LocalizableOrderByNameScope because scope ordered is already defined by WithPosition
  scope :ordered_by_name, -> (language) {
    localization_name_select = <<-SQL
      COALESCE(
        MAX(CASE WHEN localizations.language_id = '#{language.id}' THEN TRIM(LOWER(UNACCENT(localizations.name))) END),
        MAX(TRIM(LOWER(UNACCENT(localizations.name)))) FILTER (WHERE localizations.rank = 1)
      ) AS localization_name
    SQL

    # Join the table with a subquery that ranks localizations
    # The subquery assigns a rank to each localization, with 1 being the first localization for each object
    joins(sanitize_sql_array([<<-SQL
      LEFT JOIN (
        SELECT
          localizations.*,
          ROW_NUMBER() OVER(PARTITION BY localizations.about_id ORDER BY localizations.created_at ASC) as rank
        FROM
          #{table_name.singularize}_localizations as localizations
      ) localizations ON #{table_name}.id = localizations.about_id
    SQL
    ]))
    .select("#{table_name}.*", localization_name_select)
    .group("#{table_name}.id")
    .order("localization_name ASC")
  }

  scope :for_search_term, -> (term, language) {
    joins(:localizations)
      .where(education_program_localizations: { language_id: language.id })
      .where("
        unaccent(education_program_localizations.name) ILIKE unaccent(:term)
      ", term: "%#{sanitize_sql_like(term)}%")
  }
  scope :for_diploma, -> (diploma_id, language = nil) {
    where(diploma_id: diploma_id)
  }
  scope :for_school, -> (school_id, language = nil) {
    joins(:schools)
      .where(education_schools: { id: school_id })
      .distinct
  }
  scope :for_publication, -> (publication, language = nil) {
    where(published: publication)
  }

  def dependencies
    localizations +
    locations +
    university_people_through_involvements.map(&:teacher_facets) +
    university_people_through_role_involvements.map(&:administrator_facets) +
    [diploma]
  end

  def references
    schools +
    siblings +
    descendants +
    [parent]
  end

  #####################
  # WebsitesLinkable methods
  #####################

  def has_education_programs?
    true
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

  def programs
    Education::Program.where(id: id)
  end

  protected

  def check_accessibility
    accessibility_merge_array blocks
  end

  def last_ordered_element
    university.education_programs.where(parent_id: parent_id).ordered.last
  end

  def move_children
    children.update(parent_id: parent_id)
  end

end
