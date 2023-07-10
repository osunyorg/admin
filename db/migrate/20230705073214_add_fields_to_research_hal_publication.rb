class AddFieldsToResearchHalPublication < ActiveRecord::Migration[7.0]
  def change
    add_column :research_hal_publications, :citation_full, :text
    add_column :research_hal_publications, :open_access, :boolean
    add_column :research_hal_publications, :abstract, :text
    add_column :research_hal_publications, :journal_title, :string
    add_column :research_hal_publications, :file, :text
  end
end
