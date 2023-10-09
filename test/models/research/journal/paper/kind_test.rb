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
#  university_id :uuid             not null, indexed
#
# Indexes
#
#  index_research_journal_paper_kinds_on_journal_id     (journal_id)
#  index_research_journal_paper_kinds_on_slug           (slug)
#  index_research_journal_paper_kinds_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_57217513c3  (journal_id => research_journals.id)
#  fk_rails_8e6f992b9d  (university_id => universities.id)
#
require "test_helper"

class Research::Journal::Paper::KindTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
