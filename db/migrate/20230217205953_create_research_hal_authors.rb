class CreateResearchHalAuthors < ActiveRecord::Migration[7.0]
  def change
    create_table :research_hal_authors, id: :uuid do |t|
      t.string :doc_identifier
      t.string :form_identifier
      t.string :person_identifier
      t.string :first_name
      t.string :last_name
      t.string :full_name

      t.timestamps
    end

    create_join_table :research_hal_authors, :research_hal_publications, column_options: {type: :uuid} do |t|
      t.index [:research_hal_author_id, :research_hal_publication_id], name: 'hal_author_publication'
      t.index [:research_hal_publication_id, :research_hal_author_id], name: 'hal_publication_author'
    end

    create_join_table :research_hal_authors, :university_persons, column_options: {type: :uuid} do |t|
      t.index [:research_hal_author_id, :university_person_id], name: 'hal_author_person'
      t.index [:university_person_id, :research_hal_author_id], name: 'hal_person_author'
    end
  end
end
