class AddTypeToResearchPublications < ActiveRecord::Migration[8.0]
  def change
    add_column :research_publications, :doctype, :string
    add_column :research_publications, :docsubtype, :string
  end
end
