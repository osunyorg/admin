class RenameResearchHalAuthorsUniversityPersons < ActiveRecord::Migration[7.0]
  def change
    rename_table :research_hal_authors_university_persons, :research_hal_authors_university_people
  end
end
