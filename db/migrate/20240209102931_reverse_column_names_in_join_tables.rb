class ReverseColumnNamesInJoinTables < ActiveRecord::Migration[7.1]
  def change
    # research_hal_author_id, university_person_id
    rename_column :research_hal_authors_university_people, :research_hal_author_id, :temporary_id
    rename_column :research_hal_authors_university_people, :university_person_id, :research_hal_author_id
    rename_column :research_hal_authors_university_people, :temporary_id, :university_person_id

    # research_publication_id, university_person_id
    rename_column :research_publications_university_people, :research_publication_id, :temporary_id
    rename_column :research_publications_university_people, :university_person_id, :research_publication_id
    rename_column :research_publications_university_people, :temporary_id, :university_person_id

    # research_hal_author_id, research_publication_id
    rename_column :research_hal_authors_publications, :research_hal_author_id, :temporary_id
    rename_column :research_hal_authors_publications, :research_publication_id, :research_hal_author_id
    rename_column :research_hal_authors_publications, :temporary_id, :research_publication_id

    # research_laboratory_id, university_person_id
    rename_column :research_laboratories_university_people, :research_laboratory_id, :temporary_id
    rename_column :research_laboratories_university_people, :university_person_id, :research_laboratory_id
    rename_column :research_laboratories_university_people, :temporary_id, :university_person_id

    # administration_location_id, education_school_id
    rename_column :administration_locations_education_schools, :administration_location_id, :temporary_id
    rename_column :administration_locations_education_schools, :education_school_id, :administration_location_id
    rename_column :administration_locations_education_schools, :temporary_id, :education_school_id

    # administration_location_id, education_program_id
    rename_column :administration_locations_education_programs, :administration_location_id, :temporary_id
    rename_column :administration_locations_education_programs, :education_program_id, :administration_location_id
    rename_column :administration_locations_education_programs, :temporary_id, :education_program_id
  end
end
