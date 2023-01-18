class AddMastodonToPersonsAndOrganizations < ActiveRecord::Migration[7.0]
  def change
    add_column :university_people, :mastodon, :string
    add_column :university_organizations, :mastodon, :string
  end
end
