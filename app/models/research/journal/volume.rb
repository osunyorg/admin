# == Schema Information
#
# Table name: research_journal_volumes
#
#  id                    :uuid             not null, primary key
#  featured_image_alt    :string
#  featured_image_credit :text
#  keywords              :text
#  meta_description      :text
#  number                :integer
#  published             :boolean          default(FALSE)
#  published_at          :datetime
#  slug                  :string           indexed
#  summary               :text
#  text                  :text
#  title                 :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  research_journal_id   :uuid             not null, indexed
#  university_id         :uuid             not null, indexed
#
# Indexes
#
#  index_research_journal_volumes_on_research_journal_id  (research_journal_id)
#  index_research_journal_volumes_on_slug                 (slug)
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

  scope :ordered, -> (language = nil) { order(published_at: :desc, number: :desc) }

  def dependencies
    localizations +
    papers +
    people.map(&:researcher_facets)
  end

  def references
    [journal]
  end
end
