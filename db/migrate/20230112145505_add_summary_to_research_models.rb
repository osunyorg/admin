class AddSummaryToResearchModels < ActiveRecord::Migration[7.0]
  def change
    add_column :research_journals, :summary, :text
    add_column :research_journal_volumes, :summary, :text
  end
end
