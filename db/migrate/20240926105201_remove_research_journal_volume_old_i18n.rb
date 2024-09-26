class RemoveResearchJournalVolumeOldI18n < ActiveRecord::Migration[7.1]
  def change
    remove_colum :research_journal_volumes, :featured_image_alt
    remove_colum :research_journal_volumes, :featured_image_credit
    remove_colum :research_journal_volumes, :keywords
    remove_colum :research_journal_volumes, :meta_description
    remove_colum :research_journal_volumes, :published
    remove_colum :research_journal_volumes, :published_at
    remove_colum :research_journal_volumes, :slug
    remove_colum :research_journal_volumes, :summary
    remove_colum :research_journal_volumes, :text
    remove_colum :research_journal_volumes, :title
  end
end
