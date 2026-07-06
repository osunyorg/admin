# Note: I do not include this scope in the localizable concern as a big number of localized objects has another order method (position, created_at, ...)
module LocalizableOrderByNameScope
  extend ActiveSupport::Concern

  included do
    scope :ordered, -> (language) {
      # Define a raw SQL snippet for the conditional aggregation
      # This selects the name of the localization in the specified language,
      # or falls back to the first localization name if the specified language is not present.
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

  end

end
