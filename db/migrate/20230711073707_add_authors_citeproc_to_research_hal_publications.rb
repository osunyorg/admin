class AddAuthorsCiteprocToResearchHalPublications < ActiveRecord::Migration[7.0]
  def change
    add_column :research_hal_publications, :authors_citeproc, :json
  end
end
