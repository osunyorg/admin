# == Schema Information
#
# Table name: research_journal_paper_kind_localizations
#
#  id            :uuid             not null, primary key
#  slug          :string
#  title         :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  about_id      :uuid             uniquely indexed => [language_id], indexed
#  language_id   :uuid             uniquely indexed => [about_id], indexed
#  university_id :uuid             indexed
#
# Indexes
#
#  idx_on_about_id_language_id_ab294e2ab8                          (about_id,language_id) UNIQUE
#  idx_on_university_id_dc9f1267b7                                 (university_id)
#  index_research_journal_paper_kind_localizations_on_about_id     (about_id)
#  index_research_journal_paper_kind_localizations_on_language_id  (language_id)
#
# Foreign Keys
#
#  fk_rails_407795d985  (university_id => universities.id)
#  fk_rails_454222e38e  (about_id => research_journal_paper_kinds.id)
#  fk_rails_ec1bc36169  (language_id => languages.id)
#
class Research::Journal::Paper::Kind::Localization < ApplicationRecord
  include AsLocalization
  include HasGitFiles
  include Initials
  include Permalinkable
  include Sanitizable
  include WithUniversity

  validates :title, presence: true

  def git_path_relative
    "paper_kinds/#{slug}.html"
  end

  def template_static
    "admin/research/journals/papers/kinds/static"
  end

  def to_s
    "#{title}"
  end
end
