class CreateJoinTableCommunicationWebsitesLanguages < ActiveRecord::Migration[6.1]
  def change
    create_join_table :communication_websites, :languages, column_options: {type: :uuid} do |t|
      t.index [:communication_website_id, :language_id], name: 'website_language'
    end
  end
end
