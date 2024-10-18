# == Schema Information
#
# Table name: research_journal_paper_localizations
#
#  id               :uuid             not null, primary key
#  abstract         :string
#  authors_list     :text
#  keywords         :text
#  meta_description :text
#  published        :boolean          default(FALSE)
#  published_at     :datetime
#  slug             :string
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
#  index_research_journal_paper_localizations_on_about_id       (about_id)
#  index_research_journal_paper_localizations_on_language_id    (language_id)
#  index_research_journal_paper_localizations_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_50c2419b65  (language_id => languages.id)
#  fk_rails_5c86229e6a  (about_id => research_journal_papers.id)
#  fk_rails_c0d88fdf40  (university_id => universities.id)
#
class Research::Journal::Paper::Localization < ApplicationRecord
  include AsLocalization
  include Contentful
  include Initials
  include Permalinkable
  include Sanitizable
  include WithBlobs
  include WithCitations
  include WithGitFiles
  include WithPublication
  include WithUniversity

  alias :paper :about

  delegate  :journal, :volume, :people, :doi,
            to: :paper

  has_summernote :summary
  has_one_attached_deletable :pdf

  validates :title, presence: true

  def git_path(website)
    "#{git_path_content_prefix(website)}papers/#{relative_path}.html" if published?
  end

  def relative_path
    "#{published_at.year}/#{published_at.strftime "%Y-%m-%d"}-#{slug}"
  end

  def template_static
    "admin/research/journals/papers/static"
  end

  def dependencies
    active_storage_blobs +
    contents_dependencies
  end

  def journal_l10n
    paper.journal.localization_for(language)
  end

  def volume_l10n
    return unless paper.volume.present?
    paper.volume.localization_for(language)
  end

  def people_l10n
    paper.people.map { |person| person.localization_for(language) }.compact
  end

  def to_s
    "#{title}"
  end

  protected

  def to_citeproc(website: nil)
    citeproc = {
      "title" => title,
      "author" => people_l10n.map { |person|
        { "family" => person.last_name, "given" => person.first_name }
      },
      "URL" => current_permalink_url_in_website(website),
      "container-title" => journal_l10n.title,
      "volume" => volume&.number,
      "keywords" => keywords,
      "pdf" => pdf.attached? ? pdf.url : nil,
      "id" => id
    }
    citeproc["DOI"] = doi if doi.present?
    if published_at.present?
      citeproc["month-numeric"] = published_at.month.to_s
      citeproc["issued"] = { "date-parts" => [[published_at.year, published_at.month]] }
    end
    citeproc
  end

  # la vérification d'accessibilité
  def check_accessibility
    accessibility_merge_array blocks
  end

  def explicit_blob_ids
    super.concat [pdf&.blob_id]
  end
end
