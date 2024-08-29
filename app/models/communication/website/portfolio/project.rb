# == Schema Information
#
# Table name: communication_website_portfolio_projects
#
#  id                       :uuid             not null, primary key
#  featured_image_alt       :text
#  featured_image_credit    :text
#  meta_description         :text
#  published                :boolean          default(FALSE)
#  slug                     :string
#  summary                  :text
#  title                    :string
#  year                     :integer
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  communication_website_id :uuid             not null, indexed
#  language_id              :uuid             indexed
#  original_id              :uuid             indexed
#  university_id            :uuid             not null, indexed
#
# Indexes
#
#  idx_on_communication_website_id_aac12e3adb                     (communication_website_id)
#  idx_on_university_id_ac2f4a0bfc                                (university_id)
#  index_communication_website_portfolio_projects_on_language_id  (language_id)
#  index_communication_website_portfolio_projects_on_original_id  (original_id)
#
# Foreign Keys
#
#  fk_rails_5c5fb357a3  (original_id => communication_website_portfolio_projects.id)
#  fk_rails_6b220c2717  (communication_website_id => communication_websites.id)
#  fk_rails_810f9f3908  (language_id => languages.id)
#  fk_rails_a2d39c0893  (university_id => universities.id)
#
class Communication::Website::Portfolio::Project < ApplicationRecord
  include AsDirectObject
  include Contentful # TODO L10N : To remove
  include Sanitizable
  include Shareable # TODO L10N : To remove
  include Localizable
  include WithBlobs # TODO L10N : To remove
  include WithDuplication
  include WithFeaturedImage # TODO L10N : To remove
  include WithMenuItemTarget
  include WithUniversity

  # TODO L10N : remove after migrations
  has_many  :permalinks,
            class_name: "Communication::Website::Permalink",
            as: :about,
            dependent: :destroy

  has_and_belongs_to_many :categories,
                          class_name: 'Communication::Website::Portfolio::Category',
                          join_table: :communication_website_portfolio_categories_projects,
                          foreign_key: :communication_website_portfolio_project_id,
                          association_foreign_key: :communication_website_portfolio_category_id

  validates :year, presence: true

  scope :ordered, -> (language) {
    # Define a raw SQL snippet for the conditional aggregation
    # This selects the name of the localization in the specified language,
    # or falls back to the first localization name if the specified language is not present.
    localization_title_select = <<-SQL
      COALESCE(
        MAX(CASE WHEN localizations.language_id = '#{language.id}' THEN localizations.title END),
        MAX(localizations.title) FILTER (WHERE localizations.rank = 1)
      ) AS localization_title
    SQL

    # Join the projects table with a subquery that ranks localizations
    # The subquery assigns a rank to each localization, with 1 being the first localization for each organization
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

  scope :for_category, -> (category_id) {
    joins(:categories)
    .where(
      communication_website_portfolio_categories: {
        id: category_id
      }
    )
    .distinct
  }
  # TODO L10N : To adapt
  scope :for_search_term, -> (term) {
    where("
      unaccent(communication_website_portfolio_projects.meta_description) ILIKE unaccent(:term) OR
      unaccent(communication_website_portfolio_projects.summary) ILIKE unaccent(:term) OR
      unaccent(communication_website_portfolio_projects.title) ILIKE unaccent(:term)
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

  # TODO L10N : to remove
  def translate_other_attachments(translation)
    translate_attachment(translation, :shared_image) if shared_image.attached?
  end

  protected

  def abouts_with_projects_block
    website.blocks.projects.collect(&:about)
  end

end
