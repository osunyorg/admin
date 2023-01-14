class AddDoiToResearchDocuments < ActiveRecord::Migration[7.0]
  def change
    add_column :research_documents, :doi, :string
  end
end
