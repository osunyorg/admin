class RenameReferencesForBibliographyInPaper < ActiveRecord::Migration[7.0]
  def change
    rename_column :research_journal_papers, :references, :bibliography
  end
end
