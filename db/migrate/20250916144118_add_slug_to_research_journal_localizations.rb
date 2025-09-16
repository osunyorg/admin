class AddSlugToResearchJournalLocalizations < ActiveRecord::Migration[8.0]
  def change
    add_column :research_journal_localizations, :slug, :string
    Research::Journal::Localization.reset_column_information
    Research::Journal::Localization.find_each do |journal_l10n|
      journal_l10n.update_column :slug, journal_l10n.to_s.parameterize
    end
  end
end
