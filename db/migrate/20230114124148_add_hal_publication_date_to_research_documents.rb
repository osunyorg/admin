class AddHalPublicationDateToResearchDocuments < ActiveRecord::Migration[7.0]
  def change
    add_column :research_documents, :publication_date, :date
  end
end
