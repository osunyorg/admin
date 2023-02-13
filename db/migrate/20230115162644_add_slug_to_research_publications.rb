class AddSlugToResearchPublications < ActiveRecord::Migration[7.0]
  def change
    add_column :research_publications, :slug, :string
  end
end
