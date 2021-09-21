class AddFieldsToJournals < ActiveRecord::Migration[6.1]
  def change
    add_column :research_journals, :issn, :string
    add_column :research_journal_volumes, :keywords, :text
  end
end
