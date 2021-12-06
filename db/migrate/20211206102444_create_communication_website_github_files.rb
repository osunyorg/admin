class CreateCommunicationWebsiteGithubFiles < ActiveRecord::Migration[6.1]
  def change
    create_table :communication_website_github_files, id: :uuid do |t|
      t.string :github_path
      t.references :about, null: false, polymorphic: true, type: :uuid
      t.references :website, null: false, foreign_key: { to_table: :communication_websites }, type: :uuid

      t.timestamps
    end
  end
end
