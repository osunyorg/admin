class CreateFeaturesWebsitesSites < ActiveRecord::Migration[6.1]
  def change
    create_table :features_websites_sites, id: :uuid do |t|
      t.references :university, null: false, foreign_key: true, type: :uuid
      t.string :name
      t.string :domain

      t.timestamps
    end
  end
end
