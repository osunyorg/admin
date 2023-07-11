class AddAuthorsListToResearchHalPublications < ActiveRecord::Migration[7.0]
  def change
    add_column :research_hal_publications, :authors_list, :text
  end
end
