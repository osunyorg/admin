# == Schema Information
#
# Table name: communication_extranet_posts
#
#  id            :uuid             not null, primary key
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  author_id     :uuid             indexed
#  category_id   :uuid             indexed
#  extranet_id   :uuid             not null, indexed
#  university_id :uuid             not null, indexed
#
# Indexes
#
#  index_communication_extranet_posts_on_author_id      (author_id)
#  index_communication_extranet_posts_on_category_id    (category_id)
#  index_communication_extranet_posts_on_extranet_id    (extranet_id)
#  index_communication_extranet_posts_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_0232de42a1  (university_id => universities.id)
#  fk_rails_4341823eab  (extranet_id => communication_extranets.id)
#  fk_rails_7827da1fd1  (category_id => communication_extranet_post_categories.id)
#  fk_rails_86cc935add  (author_id => university_people.id)
#
class Communication::Extranet::Post < ApplicationRecord
  include Localizable
  include WithUniversity

  belongs_to :author, class_name: 'University::Person', optional: true
  belongs_to :category, class_name: 'Communication::Extranet::Post::Category', optional: true
  belongs_to :extranet, class_name: 'Communication::Extranet'

  scope :published, -> (language) { 
    joins(:localizations)
    .where(communication_extranet_post_localizations: { language_id: language.id, published: true })
    .where('communication_extranet_post_localizations.published_at <= ?', Time.zone.now)
   }
  
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
          communication_extranet_post_localizations as localizations
      ) localizations ON communication_extranet_posts.id = localizations.about_id
    SQL
    ]))
    .select("communication_extranet_posts.*", localization_pinned_select, localization_published_at_select)
    .group("communication_extranet_posts.id")
    .order("localization_pinned DESC, localization_published_at DESC, created_at DESC")
  }
end
