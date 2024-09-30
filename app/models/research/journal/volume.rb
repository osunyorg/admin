# == Schema Information
#
# Table name: research_journal_volumes
#
#  id                  :uuid             not null, primary key
#  number              :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  research_journal_id :uuid             not null, indexed
#  university_id       :uuid             not null, indexed
#
# Indexes
#
#  index_research_journal_volumes_on_research_journal_id  (research_journal_id)
#  index_research_journal_volumes_on_university_id        (university_id)
#
# Foreign Keys
#
#  fk_rails_814e97604b  (research_journal_id => research_journals.id)
#  fk_rails_c83d5e9068  (university_id => universities.id)
#
class Research::Journal::Volume < ApplicationRecord
  include AsIndirectObject
  include Localizable
  include Sanitizable
  include WithUniversity

  belongs_to  :journal,
              foreign_key: :research_journal_id
  has_many    :papers,
              foreign_key: :research_journal_volume_id,
              dependent: :nullify
  has_many    :people,
              -> { distinct },
              through: :papers

  scope :ordered, -> (language) {
    localization_published_at_select = <<-SQL
      COALESCE(
        MAX(CASE WHEN localizations.language_id = '#{language.id}' THEN localizations.published_at END),
        '1970-01-01'
      ) AS localization_published_at
    SQL

    joins(sanitize_sql_array([<<-SQL
      LEFT JOIN (
        SELECT
          localizations.*,
          ROW_NUMBER() OVER(PARTITION BY localizations.about_id ORDER BY localizations.created_at ASC) as rank
        FROM
          research_journal_volume_localizations as localizations
      ) localizations ON research_journal_volumes.id = localizations.about_id
    SQL
    ]))
    .select("research_journal_volumes.*", localization_published_at_select)
    .group("research_journal_volumes.id")
    .order("localization_published_at DESC, research_journal_volumes.number DESC")
  }

  def dependencies
    localizations +
    papers +
    people.map(&:researcher_facets)
  end

  def references
    [journal]
  end
end
