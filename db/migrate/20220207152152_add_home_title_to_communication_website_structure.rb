class AddHomeTitleToCommunicationWebsiteStructure < ActiveRecord::Migration[6.1]
  def change
    add_column :communication_website_structures, :home_title, :string, default: 'Accueil'
  end
end
