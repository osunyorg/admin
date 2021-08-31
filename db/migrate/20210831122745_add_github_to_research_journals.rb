class AddGithubToResearchJournals < ActiveRecord::Migration[6.1]
  def change
    add_column :research_journals, :access_token, :string
    add_column :research_journals, :repository, :string
  end
end
