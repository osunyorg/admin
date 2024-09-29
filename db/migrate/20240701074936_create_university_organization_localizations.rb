class CreateUniversityOrganizationLocalizations < ActiveRecord::Migration[7.1]
  def up
    create_table :university_organization_localizations, id: :uuid do |t|
      t.string  :address_additional
      t.string  :address_name
      t.string  :linkedin
      t.string  :long_name
      t.string  :mastodon
      t.text    :meta_description
      t.string  :name
      t.string  :slug
      t.text    :summary
      t.text    :text
      t.string  :twitter
      t.string  :url

      t.references :about, foreign_key: { to_table: :university_organizations }, type: :uuid
      t.references :language, foreign_key: true, type: :uuid
      t.references :university, foreign_key: true, type: :uuid

      t.timestamps
    end
  end

  def down
    drop_table :university_organization_localizations
  end
end
