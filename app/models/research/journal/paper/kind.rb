# == Schema Information
#
# Table name: research_journal_paper_kinds
#
#  id            :uuid             not null, primary key
#  slug          :string
#  title         :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  journal_id    :uuid             not null, indexed
#  university_id :uuid             not null, indexed
#
# Indexes
#
#  index_research_journal_paper_kinds_on_journal_id     (journal_id)
#  index_research_journal_paper_kinds_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_57217513c3  (journal_id => research_journals.id)
#  fk_rails_8e6f992b9d  (university_id => universities.id)
#
class Research::Journal::Paper::Kind < ApplicationRecord
  include Sanitizable
  include WithUniversity
  include WithConnections
  include WithSlug

  belongs_to :journal, class_name: 'Research::Journal'
  has_many :papers

  scope :ordered, -> { order(:title) }

  def to_s
    "#{title}"
  end
end
