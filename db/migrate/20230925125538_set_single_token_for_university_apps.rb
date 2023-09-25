class SetSingleTokenForUniversityApps < ActiveRecord::Migration[7.0]
  def change
    remove_column :university_apps, :access_key
    rename_column :university_apps, :secret_key, :token
    add_index :university_apps, :token, unique: true
    add_column :university_apps, :token_was_displayed, :boolean, default: false
  end
end
