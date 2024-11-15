# == Schema Information
#
# Table name: communication_website_posts
#
#  id                       :uuid             not null, primary key
#  migration_identifier     :string
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  author_id                :uuid             indexed
#  communication_website_id :uuid             not null, indexed
#  university_id            :uuid             not null, indexed
#
# Indexes
#
#  index_communication_website_posts_on_author_id                 (author_id)
#  index_communication_website_posts_on_communication_website_id  (communication_website_id)
#  index_communication_website_posts_on_university_id             (university_id)
#
# Foreign Keys
#
#  fk_rails_1e0d058a25  (university_id => universities.id)
#  fk_rails_d1c1a10946  (communication_website_id => communication_websites.id)
#  fk_rails_e0eec447b0  (author_id => university_people.id)
#
class Communication::Website::Post < ApplicationRecord
  include AsDirectObject
  include Duplicable
  include Filterable
  include Sanitizable
  include Localizable
  include WithMenuItemTarget
  include WithUniversity

  has_and_belongs_to_many :authors,
                          class_name: 'University::Person',
                          join_table: :communication_website_posts_university_persons,
                          foreign_key: :communication_website_post_id,
                          association_foreign_key: :university_person_id
  has_and_belongs_to_many :categories,
                          class_name: 'Communication::Website::Post::Category',
                          join_table: :communication_website_categories_posts,
                          foreign_key: :communication_website_post_id,
                          association_foreign_key: :communication_website_category_id

  after_save_commit :update_author_status_if_necessary!, if: :saved_change_to_author_id?

  scope :ordered, -> (language) {
    localization_published_at_select = <<-SQL
      COALESCE(
        MAX(CASE WHEN localizations.language_id = '#{language.id}' THEN localizations.published_at END),
        '1970-01-01'
      ) AS localization_published_at
    SQL
    localization_pinned_select = <<-SQL
      COALESCE(
        BOOL_OR(CASE WHEN localizations.language_id = '#{language.id}' THEN localizations.pinned END),
        FALSE
      ) AS localization_pinned
    SQL

    joins(sanitize_sql_array([<<-SQL
      LEFT JOIN (
        SELECT
          localizations.*,
          ROW_NUMBER() OVER(PARTITION BY localizations.about_id ORDER BY localizations.created_at ASC) as rank
        FROM
          communication_website_post_localizations as localizations
      ) localizations ON communication_website_posts.id = localizations.about_id
    SQL
    ]))
    .select("communication_website_posts.*", localization_pinned_select, localization_published_at_select)
    .group("communication_website_posts.id")
    .order("localization_pinned DESC, localization_published_at DESC, communication_website_posts.created_at DESC")
  }

  scope :latest_in, -> (language) { published_now_in(language).order("communication_website_post_localizations.published_at DESC").limit(5) }
  scope :for_author, -> (author_id, language = nil) { where(author_id: author_id) }
  scope :for_category, -> (category_id, language = nil) { joins(:categories).where(communication_website_post_categories: { id: category_id }).distinct }
  scope :for_search_term, -> (term, language) {
     joins(:localizations)
      .where(communication_website_post_localizations: { language_id: language.id })
      .where("
        unaccent(communication_website_post_localizations.meta_description) ILIKE unaccent(:term) OR
        unaccent(communication_website_post_localizations.summary) ILIKE unaccent(:term) OR
        unaccent(communication_website_post_localizations.text) ILIKE unaccent(:term) OR
        unaccent(communication_website_post_localizations.title) ILIKE unaccent(:term)
      ", term: "%#{sanitize_sql_like(term)}%")
  }

  def dependencies
    [website.config_default_content_security_policy] +
    [website.config_default_languages] +
    localizations.in_languages(website.active_language_ids) +
    categories +
    authors.map(&:author_facets) 
  end

  def references
    menus +
    abouts_with_post_block
  end

  def pinned_in?(language)
    localization_for(language).try(:pinned)
  end

  def published_at_in(language)
    localization_for(language).try(:published_at)
  end

  protected

  def update_author_status_if_necessary!
    author.update(is_author: true) if author && !author.is_author?
  end

  def abouts_with_post_block
    website.blocks.template_posts.collect(&:about)
    # Potentiel gain de performance (25%)
    # Méthode collect : X abouts = X requêtes
    # Méthode ci-dessous : X abouts = 6 requêtes
    # website.post_categories.where(id: website.blocks.template_posts.where(about_type: "Communication::Website::Post::Category").distinct.pluck(:about_id)) +
    # website.pages.where(id: website.blocks.template_posts.where(about_type: "Communication::Website::Page").distinct.pluck(:about_id)) +
    # website.posts.where(id: website.blocks.template_posts.where(about_type: "Communication::Website::Post").distinct.pluck(:about_id))
  end
end
