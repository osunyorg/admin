# == Schema Information
#
# Table name: research_journal_papers
#
#  id                         :uuid             not null, primary key
#  accepted_at                :date
#  bibliography               :text
#  doi                        :string
#  position                   :integer          not null
#  received_at                :date
#  text                       :text
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  kind_id                    :uuid             indexed
#  research_journal_id        :uuid             not null, indexed
#  research_journal_volume_id :uuid             indexed
#  university_id              :uuid             not null, indexed
#  updated_by_id              :uuid             indexed
#
# Indexes
#
#  index_research_journal_papers_on_kind_id                     (kind_id)
#  index_research_journal_papers_on_research_journal_id         (research_journal_id)
#  index_research_journal_papers_on_research_journal_volume_id  (research_journal_volume_id)
#  index_research_journal_papers_on_university_id               (university_id)
#  index_research_journal_papers_on_updated_by_id               (updated_by_id)
#
# Foreign Keys
#
#  fk_rails_05213f4f24  (research_journal_id => research_journals.id)
#  fk_rails_22f161a6a7  (research_journal_volume_id => research_journal_volumes.id)
#  fk_rails_2713063b85  (updated_by_id => users.id)
#  fk_rails_935541e014  (university_id => universities.id)
#  fk_rails_db4e38788c  (kind_id => research_journal_paper_kinds.id)
#
class Research::Journal::Paper < ApplicationRecord
  include AsIndirectObject
  include Localizable
  include Orderable
  include Sanitizable
  include Searchable
  include WithUniversity

  belongs_to  :journal,
              foreign_key: :research_journal_id
  belongs_to  :volume,
              foreign_key: :research_journal_volume_id,
              optional: true
  belongs_to  :kind,
              class_name: 'Research::Journal::Paper::Kind',
              optional: true
  belongs_to  :updated_by,
              class_name: 'User'
  has_and_belongs_to_many :people,
                          class_name: 'University::Person',
                          join_table: :research_journal_papers_researchers,
                          association_foreign_key: :researcher_id

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
          research_journal_paper_localizations as localizations
      ) localizations ON research_journal_papers.id = localizations.about_id
    SQL
    ]))
    .select("research_journal_papers.*", localization_published_at_select)
    .group("research_journal_papers.id")
    .order("localization_published_at DESC")
  }
  scope :ordered_by_position, -> { order(:position) }

  def dependencies
    localizations +
    people.map(&:researcher_facets)
  end

  def references
    refs = super + people
    refs << journal
    refs << volume if volume.present?
    refs
  end

  def doi_url
    Doi.url doi
  end

  protected

  # TODO: Maybe removable, no use
  def other_papers_in_the_volume
    return [] if volume.nil?
    volume.papers.where.not(id: self)
  end

  def last_ordered_element
    Research::Journal::Paper.where(
      university_id: university_id,
      research_journal_volume_id: research_journal_volume_id
    ).ordered_by_position.last
  end
end
