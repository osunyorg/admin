class RemoveWebsiteAttributesFromResearchJournals < ActiveRecord::Migration[7.0]
  def change
    remove_column :research_journals, :access_token, :string
    remove_column :research_journals, :repository, :string
  end
end
