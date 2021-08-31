# == Schema Information
#
# Table name: research_journal_volumes
#
#  id                  :uuid             not null, primary key
#  number              :integer
#  published_at        :datetime
#  title               :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  research_journal_id :uuid             not null
#  university_id       :uuid             not null
#
# Indexes
#
#  index_research_journal_volumes_on_research_journal_id  (research_journal_id)
#  index_research_journal_volumes_on_university_id        (university_id)
#
# Foreign Keys
#
#  fk_rails_...  (research_journal_id => research_journals.id)
#  fk_rails_...  (university_id => universities.id)
#
class Research::Journal::Volume < ApplicationRecord
  belongs_to :university
  belongs_to :journal, foreign_key: :research_journal_id
  has_many :articles, foreign_key: :research_journal_volume_id

  after_save :publish_to_github

  def to_s
    "##{ number } #{ title }"
  end

  protected

  def publish_to_github
    return if journal.repository.blank?
    Github.publish_volume self
  end
end
