# == Schema Information
#
# Table name: communication_website_portfolio_projects
#
#  id                       :uuid             not null, primary key
#  year                     :integer
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  communication_website_id :uuid             not null, indexed
#  created_by_id            :uuid             indexed
#  university_id            :uuid             not null, indexed
#
# Indexes
#
#  idx_on_communication_website_id_aac12e3adb  (communication_website_id)
#  idx_on_created_by_id_7009ee99c6             (created_by_id)
#  idx_on_university_id_ac2f4a0bfc             (university_id)
#
# Foreign Keys
#
#  fk_rails_6b220c2717  (communication_website_id => communication_websites.id)
#  fk_rails_6d5b613590  (created_by_id => users.id)
#  fk_rails_a2d39c0893  (university_id => universities.id)
#
class Communication::Website::Portfolio::Project < ApplicationRecord
  include AsDirectObject
  include Duplicable
  include Filterable
  include Sanitizable
  include Localizable
  include WithMenuItemTarget
  include WithUniversity

  belongs_to  :created_by,
              class_name: 'User',
              optional: true

  has_and_belongs_to_many :categories,
                          class_name: 'Communication::Website::Portfolio::Category',
                          join_table: :communication_website_portfolio_categories_projects,
                          foreign_key: :communication_website_portfolio_project_id,
                          association_foreign_key: :communication_website_portfolio_category_id

  validates :year, presence: true

  scope :ordered, -> (language) {
    localization_title_select = <<-SQL
      COALESCE(
        MAX(CASE WHEN localizations.language_id = '#{language.id}' THEN TRIM(LOWER(UNACCENT(localizations.title))) END),
        MAX(TRIM(LOWER(UNACCENT(localizations.title)))) FILTER (WHERE localizations.rank = 1)
      ) AS localization_title
    SQL

    joins(sanitize_sql_array([<<-SQL
      LEFT JOIN (
        SELECT
          localizations.*,
          ROW_NUMBER() OVER(PARTITION BY localizations.about_id ORDER BY localizations.created_at ASC) as rank
        FROM
          communication_website_portfolio_project_localizations as localizations
      ) localizations ON communication_website_portfolio_projects.id = localizations.about_id
    SQL
    ]))
    .select("communication_website_portfolio_projects.*", localization_title_select)
    .group("communication_website_portfolio_projects.id")
    .order("communication_website_portfolio_projects.year DESC, localization_title ASC")
  }
  scope :latest_in, -> (language) { published_now_in(language).order("communication_website_portfolio_project_localizations.updated_at DESC").limit(5) }

  scope :for_category, -> (category_id, language = nil) {
    joins(:categories)
    .where(communication_website_portfolio_categories: { id: category_id })
    .distinct
  }
  scope :for_search_term, -> (term, language) {
    joins(:localizations)
      .where(communication_website_portfolio_project_localizations: { language_id: language.id })
      . where("
      unaccent(communication_website_portfolio_project_localizations.meta_description) ILIKE unaccent(:term) OR
      unaccent(communication_website_portfolio_project_localizations.summary) ILIKE unaccent(:term) OR
      unaccent(communication_website_portfolio_project_localizations.title) ILIKE unaccent(:term)
    ", term: "%#{sanitize_sql_like(term)}%")
  }

  def dependencies
    [website.config_default_content_security_policy] +
    localizations.in_languages(website.active_language_ids)
  end

  def references
    menus +
    abouts_with_projects_block
  end

  protected

  def abouts_with_projects_block
    website.blocks.projects.collect(&:about)
  end

end
