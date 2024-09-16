class CreateCommunicationExtranetLocalizations < ActiveRecord::Migration[7.1]
  def up
    create_table :communication_extranet_localizations, id: :uuid do |t|
      t.text :cookies_policy
      t.text :home_sentence
      t.string :name
      t.text :privacy_policy
      t.string :registration_contact
      t.string :sso_button_label
      t.text :terms

      t.references :about, foreign_key: { to_table: :communication_extranets }, type: :uuid
      t.references :language, foreign_key: true, type: :uuid
      t.references :university, foreign_key: true, type: :uuid

      t.timestamps
    end
  end

  def down
    drop_table :communication_extranet_localizations
  end
end
