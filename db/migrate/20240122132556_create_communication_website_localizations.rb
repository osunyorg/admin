class CreateCommunicationWebsiteLocalizations < ActiveRecord::Migration[7.1]
  def change
    create_table :communication_website_localizations, id: :uuid do |t|
      t.references :communication_website, null: false, foreign_key: true, type: :uuid
      t.references :language, null: false, foreign_key: true, type: :uuid
      t.references :university, null: false, foreign_key: true, type: :uuid
      t.string :name
      t.string :email
      t.string :mastodon
      t.string :peertube
      t.string :x
      t.string :github
      t.string :linkedin
      t.string :youtube
      t.string :vimeo
      t.string :instagram
      t.string :facebook
      t.string :tiktok

      t.timestamps
    end
  end
end
