class FixJoinTableResearchHalPublicationsUniversityPeople < ActiveRecord::Migration[7.0]
  def change
    rename_column :research_hal_publications_university_people, :research_publication_id, :research_hal_publication_id
  end
end
