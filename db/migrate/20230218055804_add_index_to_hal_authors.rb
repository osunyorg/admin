class AddIndexToHalAuthors < ActiveRecord::Migration[7.0]
  def change
    rename_column :research_hal_authors, :doc_identifier, :docid
    add_index :research_hal_authors, :docid
  end
end
