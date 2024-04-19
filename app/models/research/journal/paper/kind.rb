# == Schema Information
#
# Table name: research_journal_paper_kinds
#
#  id            :uuid             not null, primary key
#  slug          :string           indexed
#  title         :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  journal_id    :uuid             not null, indexed
#  language_id   :uuid             not null, indexed
#  original_id   :uuid             indexed
#  university_id :uuid             not null, indexed
#
# Indexes
#
#  index_research_journal_paper_kinds_on_journal_id     (journal_id)
#  index_research_journal_paper_kinds_on_language_id    (language_id)
#  index_research_journal_paper_kinds_on_original_id    (original_id)
#  index_research_journal_paper_kinds_on_slug           (slug)
#  index_research_journal_paper_kinds_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_4ee2e9e2d4  (original_id => research_journal_paper_kinds.id)
#  fk_rails_57217513c3  (journal_id => research_journals.id)
#  fk_rails_8e6f992b9d  (university_id => universities.id)
#  fk_rails_fa47741536  (language_id => languages.id)
#
class Research::Journal::Paper::Kind < ApplicationRecord
  include AsIndirectObject
  include Sanitizable
  include Sluggable
  include WithGitFiles
  include WithUniversity

  belongs_to :journal, class_name: 'Research::Journal'
  has_many :papers

  scope :ordered, -> { order(:title) }

  def to_s
    "#{title}"
  end
end
