# == Schema Information
#
# Table name: research_journal_papers
#
#  id                         :uuid             not null, primary key
#  abstract                   :text
#  accepted_at                :date
#  authors_list               :text
#  bibliography               :text
#  doi                        :string
#  keywords                   :text
#  meta_description           :text
#  position                   :integer
#  published                  :boolean          default(FALSE)
#  published_at               :datetime
#  received_at                :date
#  slug                       :string           indexed
#  summary                    :text
#  text                       :text
#  title                      :string
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
#  index_research_journal_papers_on_slug                        (slug)
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
  include Contentful # TODO L10N : To remove
  include Localizable
  include Sanitizable
  include WithBlobs # TODO L10N : To remove
  include WithPosition
  include WithUniversity

  # TODO L10N : remove after migrations
  has_many  :permalinks,
            class_name: "Communication::Website::Permalink",
            as: :about,
            dependent: :destroy

  has_one_attached :pdf # TODO L10N : To remove

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

  scope :ordered, -> (language) { order(published_at: :desc) }
  scope :ordered_by_position, -> { order(:position) }

  def dependencies
    localizations +
    contents_dependencies +
    people.map(&:researcher)
  end

  def references
    references = people + [journal]
    references << volume if volume.present?
    references
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
    ).ordered.last
  end
end
