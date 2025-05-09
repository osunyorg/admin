# == Schema Information
#
# Table name: research_journal_localizations
#
#  id               :uuid             not null, primary key
#  issn             :string
#  meta_description :text
#  summary          :text
#  title            :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  about_id         :uuid             indexed
#  language_id      :uuid             indexed
#  university_id    :uuid             indexed
#
# Indexes
#
#  index_research_journal_localizations_on_about_id       (about_id)
#  index_research_journal_localizations_on_language_id    (language_id)
#  index_research_journal_localizations_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_0b779bef15  (university_id => universities.id)
#  fk_rails_68127f1bdd  (language_id => languages.id)
#  fk_rails_c51f4f55df  (about_id => research_journals.id)
#
class Research::Journal::Localization < ApplicationRecord
  include AsLocalization
  include HasGitFiles
  include Initials
  include Sanitizable
  include WithUniversity

  has_summernote :summary

  validates :title, presence: true

  def git_path(website)
    "data/journal.yml"
  end

  def template_static
    "admin/research/journals/static"
  end

  def to_s
    "#{title}"
  end
end
