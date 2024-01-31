class RenameHalPublications < ActiveRecord::Migration[7.1]
  def change
    rename_column :research_hal_authors_publications, :research_hal_publication_id, :research_publication_id
    
    rename_table :research_hal_publications_university_people, :research_publications_university_people
    rename_column :research_publications_university_people, :research_hal_publication_id, :research_publication_id

    # Vieil index problématique
    # https://stackoverflow.com/questions/32395126/rename-table-relation-table-pkey-does-not-exist
    execute "ALTER INDEX research_documents_pkey RENAME TO research_hal_publications_pkey;"
    rename_table :research_hal_publications, :research_publications
    rename_column :research_publications, :docid, :hal_docid
    add_column :research_publications, :source, :integer, default: 0
    # All existing publications are from HAL at this moment
    Research::Publication.update_all source: 1
  end
end
