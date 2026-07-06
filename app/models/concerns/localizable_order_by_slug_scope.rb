module LocalizableOrderBySlugScope
  extend ActiveSupport::Concern

  # Cf LocalizableOrderByNameScope
  included do
    scope :ordered, -> (language) {
      localization_name_select = <<-SQL
        COALESCE(
          MAX(CASE WHEN localizations.language_id = '#{language.id}' THEN TRIM(LOWER(UNACCENT(localizations.slug))) END),
          MAX(TRIM(LOWER(UNACCENT(localizations.slug)))) FILTER (WHERE localizations.rank = 1)
        ) AS localization_slug
      SQL

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
      .order("localization_slug ASC")
    }
  end
end
