class AddAnrProjectsToResearchPublications < ActiveRecord::Migration[8.0]
  def change
    add_column :research_publications, :anr_project_references, :text, array: true, default: []
  end
end
