class RenameDocumentToPublication < ActiveRecord::Migration[7.0]
  def change
    rename_table :research_documents, :research_publications

    remove_column :research_publications, :university_id, :uuid
    remove_column :research_publications, :university_person_id, :uuid

    create_join_table :research_publications, :university_people, column_options: {type: :uuid} do |t|
      t.index [:research_publication_id, :university_person_id], name: 'index_publication_person'
      t.index [:university_person_id, :research_publication_id], name: 'index_person_publication'
    end

    create_join_table :research_publications, :research_laboratories, column_options: {type: :uuid} do |t|
      t.index [:research_publication_id, :research_laboratory_id], name: 'index_publication_laboratory'
      t.index [:research_laboratory_id, :research_publication_id], name: 'index_laboratory_publication'
    end
  end
end
