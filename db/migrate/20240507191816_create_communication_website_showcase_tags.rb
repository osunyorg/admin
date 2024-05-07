class CreateCommunicationWebsiteShowcaseTags < ActiveRecord::Migration[7.1]
  def change
    create_table :communication_website_showcase_tags, id: :uuid do |t|
      t.string :name
      t.string :slug

      t.timestamps
    end
  end
end
