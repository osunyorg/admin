class MovePublicationsInHal < ActiveRecord::Migration[7.0]
  def change
    rename_table :research_publications, :research_hal_publications
    rename_table :research_publications_university_people, :research_hal_publications_university_people
    drop_table :research_laboratories_publications
  end
end
