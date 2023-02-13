class AddHalUrlToResearchDocuments < ActiveRecord::Migration[7.0]
  def change
    add_column :research_documents, :hal_url, :string
  end
end
