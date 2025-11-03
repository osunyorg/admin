# == Schema Information
#
# Table name: research_journal_localizations
#
#  id               :uuid             not null, primary key
#  issn             :string
#  meta_description :text
#  slug             :string
#  summary          :text
#  title            :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  about_id         :uuid             uniquely indexed => [language_id], indexed
#  language_id      :uuid             uniquely indexed => [about_id], indexed
#  university_id    :uuid             indexed
#
# Indexes
#
#  idx_on_about_id_language_id_c2c2f792ff                 (about_id,language_id) UNIQUE
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
  include Permalinkable
  include Sanitizable
  include WithUniversity

  has_summernote :summary

  validates :title, presence: true

  def git_path_relative
    "journals/#{slug}.html"
  end

  def template_static
    "admin/research/journals/static"
  end

  def to_s
    "#{title}"
  end
end
